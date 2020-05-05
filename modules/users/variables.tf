variable "create_users" {
  description = "Controls whether an IAM user will be created"
  type        = bool
  default     = true
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
   }))
     default = []
}
   
