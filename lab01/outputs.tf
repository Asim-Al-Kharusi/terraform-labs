output "application_name" {
  value = var.application_name
}
output "environment_name" {
  value = var.environment_name
}
output "environment_prefix" {
  value = local.environment_prefix
}
output "suffix" {
  value = random_string.suffix.result
}
output "api_key" {
  value     = var.api_key
  sensitive = true
}
output "primary_reigon" {
  value = var.reigons[1]
}
output "primary_reigon_instance_count" {
  value = var.reigon_instance_count[var.reigons[1]]
}
output "kind" {
  value = var.sku_settings.kind
}
output "reigonA" {
  value = module.regional_stamps["learn_terraform_regionA"].region
}
output "reigonB" {
  value = module.regional_stamps["learn_terraform_regionB"].region
}
