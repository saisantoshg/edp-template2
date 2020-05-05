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
  count      = length(var.s3_client_buckets)
  bucket     = var.s3_client_buckets[count.index]
  block_public_acls   = true
  block_public_policy = true
}
