provider "aws"{
  version = "2.33.0"
  region="ap-south-1"
}

resource "aws_s3_bucket" "s3_client_bucket" {
  count      = length(var.s3_client_buckets)
  bucket = var.s3_client_buckets[count.index]
  acl    = "private"

  tags = {
    count      = length(var.s3_client_buckets)
    Name       = var.s3_client_buckets[count.index]
    Environment = var.client_env
  }
  
   versioning {
    enabled = true
  }
  
  lifecycle_rule {
    id      = "clientfiles_storage_rules"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.s3_client_bucket.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_iam_user" "user1" {
  for_each = var.client_users_s3bucket_map
  
  name=each.key

}


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

