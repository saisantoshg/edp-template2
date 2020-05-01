variable "s3_client_buckets"{
   type = string
}
variable "client_env" {
    type= string
}
variable "iam_glue_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = list(string)
}
variable "client_users_s3buckets_maps"{
   type=map(string)
   description ="mapping users and clients"
}
