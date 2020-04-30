variable "client_name"{
   type = string
}
variable "client_env" {
    type= string
}
variable "iam_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = "list"
}
