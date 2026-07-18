data "scaleway_block_snapshot" "snapshot" {
  name = var.snapshot_name
}

resource "scaleway_block_volume" "from_snapshot" {
  snapshot_id = data.scaleway_block_snapshot.snapshot.id
  iops        = 5000
}

resource "scaleway_instance_security_group" "this" {
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action   = "accept"
    port     = 6443
    protocol = "TCP"
  }

  inbound_rule {
    action   = "accept"
    port     = 5000
    protocol = "TCP"
  }
}

resource "scaleway_instance_server" "from_snapshot" {
  type = var.scaleway_instance_server_type

  root_volume {
    volume_id   = scaleway_block_volume.from_snapshot.id
    volume_type = "sbs_volume"
  }

  additional_volume_ids = var.additional_volume_ids
  security_group_id     = scaleway_instance_security_group.this.id
}

resource "scaleway_ipam_ip" "this" {
  address = var.ip
  source {
    private_network_id = var.private_network_id
  }
}

resource "scaleway_instance_private_nic" "nic01" {
  server_id          = scaleway_instance_server.from_snapshot.id
  private_network_id = var.private_network_id
  ipam_ip_ids        = [scaleway_ipam_ip.this.id]
}

resource "scaleway_vpc_public_gateway_pat_rule" "pat_50000" {
  gateway_id   = var.gateway_id
  private_ip   = scaleway_instance_private_nic.nic01.private_ips[0].address
  private_port = 50000
  public_port  = 50000
  protocol     = "tcp"
}

resource "scaleway_vpc_public_gateway_pat_rule" "pat_6443" {
  gateway_id   = var.gateway_id
  private_ip   = scaleway_instance_private_nic.nic01.private_ips[0].address
  private_port = 6443
  public_port  = 6443
  protocol     = "tcp"
}
