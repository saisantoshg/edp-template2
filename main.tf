provider "aws"{
  version = "2.33.0"
  region="ap-south-1"
}

module "s3_buckets" {
  source = "./modules/s3_buckets/"

  create_buckets           = var.create_buckets
  s3_client_buckets        = var.s3_client_buckets

}
  
module "glue_s3_role" {
  source = "./modules/roles/"

  create_role              = var.create_role
  iam_glue_policy_arn      = var.iam_glue_policy_arn

}

 
