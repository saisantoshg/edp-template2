provider "aws"{
  version = "2.33.0"
  region="ap-south-1"
}



locals {
  users_map = { for user in var.users : user.name => user }
  #users_map = { for user in var.users : user.name => user }

  # Construct list of inline policy maps for use with for_each
  # https://www.terraform.io/docs/configuration/functions/flatten.html#flattening-nested-structures-for-for_each
  inline_policy_ids = flatten([
    for user in var.users : [
      for inline_policy in lookup(user, "inline_policy_names", []) : {
        id          = "${user.name}:${inline_policy}"
        user_name   = user.name
        policy_name = inline_policy
      }
    ]
  ])
}

  
module "inline_policy_documents" {
  source = "../policy_documents"

  create_policy_documents = var.create_users

  policy_names = local.inline_policy_ids[*].id

  policies = [
    for policy in local.inline_policies : {
      name           = policy.id,
      template       = policy.template
      template_paths = policy.template_paths
      template_vars  = policy.template_vars
    }
  ]
}

  
  
# create the IAM users
resource "aws_iam_user" "this" {
  for_each = var.create_users ? local.users_map : {}

  name = each.key
  force_destroy        = each.value.force_destroy
  path                 = each.value.path
  #permissions_boundary = each.value.permissions_boundary != null ? var.policy_arns[index(var.policy_arns, each.value.permissions_boundary)] : null

  # Merge module-level tags with tags set in the user-schema
  #tags = merge(var.tags, lookup(each.value, "tags", {}))
}
  
  
  
# create inline policies for the IAM users
resource "aws_iam_user_policy" "this" {
  for_each = var.create_users ? { for policy in local.inline_policy_ids : policy.id => policy } : {}

  name   = each.value.policy_name
  user   = aws_iam_user.this[each.value.user_name].id
  policy = module.inline_policy_documents.policies[each.key]
}
    
