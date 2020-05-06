variable "group_map" {
  description = "attaching policies to groups"
  type = map(object({
      groupname = string
      policies = list(string)
    }))
}
