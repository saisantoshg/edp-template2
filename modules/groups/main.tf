locals {
  policy_attachments = flatten([
    for groupname, policies in var.group_map : [
      for policy_arn in policies: {
        groupname   = groupname
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
    
resource "aws_iam_group" "Clients" {
  name = "Clients"
  path = "/groups/"
}


