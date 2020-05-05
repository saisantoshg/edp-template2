variable "create_users" {
  description = "Controls whether an IAM user will be created"
  type        = bool
  default     = true
}

variable "policy_arns" {
  description = "List of all managed policy ARNs used in the users object. This is needed to properly order policy attachments/detachments on resource cycles"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Map of tags to apply to the IAM users. Merged with tags set per-user in the user-schema"
  type        = map(string)
  default     = {}
}

variable "users" {
  description = "Schema list of IAM users"
  type = list(object({
    name                 = string
    force_destroy        = bool
    path                 = string
    permissions_boundary = string
    tags                 = map(string)
    policy_arns          = list(string)
    inline_policies = list(object({
      name           = string
      template       = string
      template_paths = list(string)
      template_vars  = map(string)
    }))
}
