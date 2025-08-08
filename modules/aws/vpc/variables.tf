variable "zones_count" {
  description = "zones count for VPC"
  type        = number
  default     = 1
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for subnet"
  type        = list(string)
  default     = ["us-east-1a"]
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for subnets"
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "assign_ipv6" {
  description = "ipv6 assignment for VPC"
  type        = bool
  default     = true
}