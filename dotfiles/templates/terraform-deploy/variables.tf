#
# Remote state.
#

variable "aws_region" {
  type = string
}

variable "tf_state_bucket_name" {
  description = "The name of the bucket that contains remote states."
  type        = string
}

variable "tf_state_bucket_region" {
  description = "The region of the bucket that contains remote states."
  type        = string
}

#
# Environment
#

variable "environment" {
  description = "Envionment name to use for resources naming"
  type        = string
}

#
# Networking
#

variable "vpc_id" {
  type        = string
  description = "Vpc id for resources"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids for resources"
}