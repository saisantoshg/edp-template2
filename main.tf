provider "aws"{
  version = "2.33.0"
  region="ap-south-1"
}

resource "aws_s3_bucket" "s3_client_bucket" {
  bucket = "my-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
