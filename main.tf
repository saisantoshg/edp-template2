provider "aws"{
  version = "2.33.0"
  region="ap-south-1"
}

resource "aws_s3_bucket" "s3_client_bucket" {
  bucket = var.client_name
  acl    = "private"

  tags = {
    Name        = var.client_name
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
  bucket = "${aws_s3_bucket.s3_client_bucket.id}"

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_iam_user" "user1" {
  name = "user1"
  path = "/system/"

  tags = {
    tag-key = "user1"
  }
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
  role       = "${aws_iam_role.glue_rds_s3_access_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
resource "aws_iam_role_policy_attachment" "glue_role-attach2" {
  role       = "${aws_iam_role.glue_rds_s3_access_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

