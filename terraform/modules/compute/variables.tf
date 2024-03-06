
variable "name" {
  description = "The name of the instance."
  type        = string
}

variable "region" {
  description = "The region in which the instance will run."
  type        = string
}

variable "zone" {
  description = "The zone in which the instance will run."
  type        = string
}

variable "machine_type" {
  description = "The machine type to use for the instance."
  type        = string
  default     = "e2-small"
}

variable "boot_image" {
  description = "The image to use for the boot disk."
  type        = string
  default     = "projects/debian-cloud/global/images/debian-12-bookworm-v20240213"
}

variable "project_name" {
  description = "The name of the project."
  type        = string
}

# variable "service_account" {
#   description = "The service account to use for the instance."
#   type        = string
# }
