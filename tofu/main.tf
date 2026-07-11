locals {
  prefix = var.prefix
}
module "bucket_scw" {
  source = "./modules/scw/bucket"
  name   = "${local.prefix}-talos-img"
}
