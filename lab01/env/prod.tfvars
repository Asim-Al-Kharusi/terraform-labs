environment_name = "prod"
instance_count   = 7
enabled          = false
reigons          = ["ukwest", "uksouth"]
reigon_instance_count = {
  "ukwest"  = 4
  "uksouth" = 8
}
reigon_set = ["ukwest", "uksouth"]
sku_settings = {
  kind = "P"
  tier = "Business"
}
