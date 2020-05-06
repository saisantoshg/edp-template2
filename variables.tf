variable "group_map" {
  description = "attaching policies to groups"
  type = list(object({
      groupname=string
      policies=list(string)
    }))
}
