data "external" "talos_snapshot" {
  program = ["${path.module}/scripts/import-snapshot.sh"]

  query = {
    zone   = var.zone
    name   = var.snapshot_name
    bucket = var.bucket_name
    key    = var.object_key
    size   = var.snapshot_size
  }
}
