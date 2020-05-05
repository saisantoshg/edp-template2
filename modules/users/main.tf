provider "aws"{
  version = "2.33.0"
  region="ap-south-1"
}



locals {
  users_map = { for user in var.users : user.name => user }
  #users_map = { for user in var.users : user.name => user }

  # Construct list of inline policy maps for use with for_each
  # https://www.terraform.io/docs/configuration/functions/flatten.html#flattening-nested-structures-for-for_each
  inline_policies = flatten([
    for user in var.users : [
      for inline_policy in lookup(user, "inline_policies", []) : {
        id             = "${user.name}:${inline_policy.name}"
        user_name      = user.name
        policy_name    = inline_policy.name
        template       = inline_policy.template
        template_paths = inline_policy.template_paths
        template_vars  = inline_policy.template_vars
      }
    ]
  ])
}
    

module "inline_policy_documents" {
  source = "../policy_documents"

  create_policy_documents  = var.create_users

  policies = [
    for policy_map in local.inline_policies : {
      name           = policy_map.id,
      template       = policy_map.template
      template_paths = policy_map.template_paths
      template_vars  = policy_map.template_vars
    }
  ]
}

  
  
# create the IAM users
resource "aws_iam_user" "this" {
  for_each = var.users ? local.users_map : {}

  name = each.key

  force_destroy        = each.value.force_destroy
  path                 = each.value.path
  #permissions_boundary = each.value.permissions_boundary != null ? var.policy_arns[index(var.policy_arns, each.value.permissions_boundary)] : null

  # Merge module-level tags with tags set in the user-schema
  #tags = merge(var.tags, lookup(each.value, "tags", {}))
}
  
  
  
# create inline policies for the IAM users
resource "aws_iam_user_policy" "this" {
  for_each = var.client_users_bucket_mapping ? { for policy_map in local.inline_policies : policy_map.id => policy_map } : {}

  name   = each.value.policy_name
  user   = aws_iam_user.this[each.value.user_name].id
  policy = module.inline_policy_documents.policies[each.key]
}
