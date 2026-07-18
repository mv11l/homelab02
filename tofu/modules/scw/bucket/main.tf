resource "scaleway_object_bucket" "this" {
  name = var.name
  tags = {
    provider = "scw"
  }
}

resource "scaleway_object" "this" {
  for_each = toset(var.files)

  bucket = scaleway_object_bucket.this.id
  key    = basename(each.key)

  file = each.key
  hash = filemd5(each.key)
}
