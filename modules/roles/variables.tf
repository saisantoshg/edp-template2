variable "create_role"{
   type = bool
   default = true
}
variable "iam_glue_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = list(string)
}
