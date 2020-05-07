resource "aws_iam_user" "u1" {
  name = "Santosh"
  path = "/user/"

  tags = {
    tag-key = "Santosh"
  }
}
