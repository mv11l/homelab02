resource "scaleway_object_bucket" "this" {
  name = var.name
  tags = {
    provider = "scw"
  }
}
