locals {
  policy_attachments = flatten([
    for i in keys(var.group_map) : [
      for j in var.group_map[i]: {
        group  = i
        policy_arn = j
      }
    ]
  ])
}


resource "aws_iam_group" "EC2_RDS" {
  name = "EC2_RDS"
  path = "/groups/"
}

resource "aws_iam_group" "SparxEA" {
  name = "SparxEA"
  path = "/groups/"
}

resource "aws_iam_group" "ViewBilling" {
  name = "ViewBilling"
  path = "/groups/"
}

 resource "aws_iam_group_policy_attachment" "group_attach"{
    foreach = {
      for up in var.policy_attachments :
        "${up.groupname} ${up.policy_arn}" => up
     }
      group      = each.value.group
      policy_arn = each.value.policy_arn
  }

