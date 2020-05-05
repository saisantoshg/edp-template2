resource "aws_iam_role" "glue_rds_s3_access_role" {
  name = "glue_rds_s3_access_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy_attachment" "glue_role-attach1" {
  role       = aws_iam_role.glue_rds_s3_access_role.name
  count      = length(var.iam_glue_policy_arn)
  policy_arn = var.iam_glue_policy_arn[count.index]
}
