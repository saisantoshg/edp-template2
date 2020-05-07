locals {
  policy_attachments = flatten([
    for group in keys(var.group_map) : [
      for policy_arn in var.group_map[group]: {
        group  = group
        policy_arn = policy_arn
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
    

