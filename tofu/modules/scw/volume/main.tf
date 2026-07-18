resource "scaleway_block_volume" "this" {
  size_in_gb = var.block_vol_size
  iops       = 5000
}

