variable "vpc_name" {
  type    = string
  default = ""
}

variable "vpc_tags" {
  type    = list(string)
  default = [""]
}

variable "vpc_enable_routing" {
  type    = bool
  default = false
}

variable "vpc_private_network_name" {
  type    = string
  default = ""
}
variable "vpc_private_network_ipv4_subnet" {
  type = string
}

variable "vpv_public_gateway_type" {
  type    = string
  default = "VPC-GW-S"
}
