variable "bucket_name" {
  type = string
}

variable "object_key" {
  type = string
}

variable "object_path" {
  type = string
}

variable "create_bucket" {
  type    = bool
  default = true
}
