variable "s3_client_buckets"{
   type = list(string)
}
variable "client_env" {
    type = string
}
variable "iam_glue_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = list(string)
}
variable "client_users_bucket_mapping"{
   type = map(string)
   description ="mapping client users and clients s3 buckets"
}
