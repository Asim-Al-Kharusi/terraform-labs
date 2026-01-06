environment_name = "test"
instance_count   = 5
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
