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
variable "client_users_bucket_mapping"{
   type = map(string)
   description ="mapping client users and clients s3 buckets"
}
variable "users" {
  description = "Schema list of IAM users"
  type = list(object({
    name                 = string
    force_destroy        = bool
    path                 = string
    tags                 = map(string)
    inline_policies = list(object({
      name           = string
      template       = string
      template_paths = list(string)
      template_vars  = map(string)
    }))
     default = []
}
     
    
