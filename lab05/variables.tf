variable "application_name" {
  type        = string
  description = "name of application"
}
variable "primary_location" {
  type        = string
  description = "deployment reigon"
}
variable "environment_name" {
  type        = string
  description = "working environment"
}
variable "base_address_space" {
  type        = string
  description = "base CIDR address space for virtual network"
}
