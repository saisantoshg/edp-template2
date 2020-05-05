variable "s3_client_buckets"{
   description = "list of s3 buckets to be created"
   type = list(string)
}
variable "client_env" {
    type = string
}
variable "create_buckets"{
     description = "Controls whether to create s3 buckets"
     type = bool
     default = true
 }
