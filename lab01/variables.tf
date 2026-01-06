variable "application_name" {
  type = string

  validation {
    condition     = length(var.application_name) <= 12
    error_message = "Application name must be 12 characters or less."
  }
}

variable "environment_name" {
  type = string
}

variable "api_key" {
  type      = string
  sensitive = true

}
variable "instance_count" {
  type = number

  validation {
    condition     = var.instance_count >= local.min_nodes && var.instance_count < local.max_nodes && var.instance_count % 2 != 0
    error_message = "Instances must be an odd number between 1 and 10."
  }
}
variable "enabled" {
  type = bool
}
variable "reigons" {
  type = list(string)
}
variable "reigon_instance_count" {
  type = map(string)
}
variable "reigon_set" {
  type = set(string)
}
variable "sku_settings" {
  type = object({
    kind = string
    tier = string
  })
}
