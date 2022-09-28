#
# Naming
#

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

variable "vpc_id" {
  type        = string
  description = "vpc id to use for resources"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet to use for resources"
}
