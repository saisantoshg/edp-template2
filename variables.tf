variable "create_buckets"{
   type = bool
   default = true
}
variable "create_role"{
   type = bool
   default = true
}
variable "create_users"{
   type = bool
   default = true
}
variable "s3_client_buckets"{
   type = list(string)
}
variable "iam_glue_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = list(string)
}
variable "group_map" {
  description = "attaching policies to groups"
  type = map(string)
}
