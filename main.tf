provider "aws"{
  version = "2.33.0"
  region="ap-south-1"
}

resource "aws_s3_bucket" "s3_client_bucket" {
  bucket = var.client_name
  acl    = "private"

  tags = {
    Name        = var.client_name
    Environment = var.dev
  }
}
