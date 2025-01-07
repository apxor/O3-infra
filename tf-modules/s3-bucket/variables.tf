variable "bucket_name" {
  type        = string
  description = "name of the s3 bucket"
}

variable "force_destroy_enabled" {
  type        = bool
  description = "whether to enable force destroy.. if enabled terraform can delete the s3 bucket."
  default     = false
}

variable "block_public_access" {
  type    = bool
  default = true
}

variable "create_user_access_credentials" {
  type    = bool
  default = false
}

variable "enable_bucket_versioning" {
  type    = bool
  default = false
}

variable "expiry" {
  type    = number
  default = 0
  description = "expiry in days for the objects in the bucket"
}

