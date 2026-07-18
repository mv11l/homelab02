variable "project_id" {
  type        = string
  description = "Your project ID."
}

variable "zone" {
  type        = string
  description = "Scw zones."
}

variable "region" {
  type        = string
  description = "Scw region."
}

variable "bucket_state_access_key" {
  type = string
}

variable "bucket_state_secret_key" {
  type = string
}

variable "prefix" {
  type        = string
  description = "Prefix is used to global scope ressources"
}

variable "talos_img_path" {
  type = string
}
