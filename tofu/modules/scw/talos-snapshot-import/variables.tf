variable "zone" {
  type    = string
  default = "fr-par-1"
}
variable "snapshot_name" { type = string }
variable "bucket_name" { type = string }
variable "object_key" { type = string }
variable "snapshot_size" {
  type    = string
  default = "10GB"
}
