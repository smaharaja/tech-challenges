
environment             = "dev"
vnet_cidr               = ["10.100.0.0/23"]
web_subnet_cidr         = ["10.100.0.0/26"]
app_subnet_cidr         = ["10.100.0.64/26"]
privatelink_subnet_cidr = ["10.100.0.128/26"]

# Use Plans for testing as F1, SHARED, B1, S1 or P1v2
app_service_plan = "S1"

# Use Basic or S1 for testing
sqldb_sku = "Basic"
