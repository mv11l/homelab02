output "vpc_name" {
  value = scaleway_vpc.this.id
}

output "vpc_created_at" {
  value = scaleway_vpc.this.created_at
}

output "private_network_id" {
  value = scaleway_vpc_private_network.this.id
}

output "gateway_id" {
  value = scaleway_vpc_public_gateway.this.id
}

output "gateway_network_id" {
  value = scaleway_vpc_gateway_network.this.id
}

output "public_ip" {
  value = scaleway_vpc_public_gateway_ip.this.address
}
