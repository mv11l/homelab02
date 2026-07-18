output "snapshot_id" {
  value = data.external.talos_snapshot.result.id
}

output "snapshot_name" {
  value = var.snapshot_name
}

output "snapshot_status" {
  value = data.external.talos_snapshot.result.status
}
