variable "total" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "subnet_cidr_blocks" {
  type = list(string)
}