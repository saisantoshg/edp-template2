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
