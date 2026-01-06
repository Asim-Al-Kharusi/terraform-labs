environment_name = "dev"
instance_count   = 5
enabled          = true
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
