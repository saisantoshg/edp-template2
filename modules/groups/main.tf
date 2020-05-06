provider "aws"{
  version = "2.33.0"
  region="ap-south-1"
}

resource "aws_iam_group" "EC2+RDS" {
  name = "EC2+RDS"
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
