#===<modules>/dev/vpc/variables.tf---#

variable "az" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "subnet_cidr_block" {
  type = string
}