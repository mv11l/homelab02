locals {
  prefix = "${var.prefix}-"
}

#WAIT GOOD NETWORK :) ILE DE RE STYLE
# module "bucket_scw" {
#   source = "./modules/scw/bucket"
#   name   = "${local.prefix}talos-img"
#   files = [
#     var.talos_img_path
#   ]
# }

module "talos_snapshot" {
  source        = "./modules/scw/talos-snapshot-import"
  zone          = var.zone
  snapshot_name = "talos-scaleway-amd64-v1.13.6"
  bucket_name   = "${local.prefix}talos-img" # module.bucket_scw.bucket_name
  object_key    = "scaleway-amd64.qcow2"
  snapshot_size = "10GB"
}

module "network" {
  source                          = "./modules/scw/network"
  vpc_name                        = "${local.prefix}vpc"
  vpc_enable_routing              = true
  vpc_tags                        = ["scw", "vpc"]
  vpc_private_network_name        = "${local.prefix}pvn"
  vpc_private_network_ipv4_subnet = "192.168.1.0/24"
}

module "volume" {
  source         = "./modules/scw/volume"
  block_vol_size = 25
}

module "instance" {
  source                        = "./modules/scw/instances"
  snapshot_name                 = module.talos_snapshot.snapshot_name
  scaleway_instance_server_type = "PLAY2-NANO"
  private_network_id            = module.network.private_network_id
  ip                            = "192.168.1.3"
  gateway_id                    = module.network.gateway_id
  depends_on                    = [module.talos_snapshot, module.network]
  additional_volume_ids         = [module.volume.scaleway_block_volume_id]
}

