variable "snapshot_name" {
  type    = string
  default = ""
}

variable "private_network_id" {
  type = string
}

variable "gateway_id" {
  type = string
}

variable "ip" {
  type = string
}

variable "scaleway_instance_server_type" {
  type = string
}

variable "additional_volume_ids" {
  type = list(string)
}
