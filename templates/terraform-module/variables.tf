### Naming

variable "naming" {
  type = object({
    name          = string,
    project       = string,
    environment   = string,
    application   = string,
    corporation   = string,
    owner         = string,
    business_unit = string,
    tenant        = string,
    tags          = map(string)
  })
  description = "Map of tags to use for naming of resources"
}

### Networking

variable "subnet_id" {
  type        = string
  description = "Subnet ids to use for resources"
  default     = null
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of security groups ID to be associated with instances"
  default     = null
}
