resource "scaleway_vpc" "this" {
  name           = var.vpc_name
  tags           = var.vpc_tags
  enable_routing = var.vpc_enable_routing
}
resource "scaleway_vpc_private_network" "this" {
  name   = var.vpc_private_network_name
  vpc_id = scaleway_vpc.this.id
  tags   = []

  ipv4_subnet {
    subnet = var.vpc_private_network_ipv4_subnet
  }
}
resource "scaleway_vpc_public_gateway_ip" "this" {}

resource "scaleway_vpc_public_gateway" "this" {
  name  = "${var.vpc_name}-gw"
  type  = var.vpv_public_gateway_type
  ip_id = scaleway_vpc_public_gateway_ip.this.id
}

resource "scaleway_vpc_gateway_network" "this" {
  gateway_id         = scaleway_vpc_public_gateway.this.id
  private_network_id = scaleway_vpc_private_network.this.id
  enable_masquerade  = true
  ipam_config {
    push_default_route = true
  }
}
