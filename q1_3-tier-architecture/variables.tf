
# Preset Infrastructure Variables
variable "environment" {
  description = "Environment Name Where Infrastructure Gets Deployed. Values can be dev, qa, stg and prod"
  type        = string
  validation {
    condition     = contains(["dev", "qa", "stg", "prod"], var.environment)
    error_message = "Environment Name must be dev, qa, stg or prod"
  }
}

variable "location" {
  description = "Azure Region Where Resources Will Be Created"
  type        = string
  default     = "Central India"
}

variable "owner_name" {
  description = "Name of the Owner of the Infrastructure"
  type        = string
  default     = "Santosh Raundhal"
}

variable "owner_email" {
  description = "Email of the Owner of the Infrastructure"
  type        = string
  default     = "santosh.maharaja@gmail.com"
}

variable "project" {
  description = "Project Name Under Resources Are Getting Billed"
  type        = string
  default     = "Assessment Challenges"
}


# Application Environment Variables
variable "vnet_cidr" {
  description = "Address Space for Virtual Network"
  type        = list(string)
  validation {
    condition     = length(var.vnet_cidr) > 0
    error_message = "Must be atleast 1 cidr present"
  }
}

variable "web_subnet_cidr" {
  description = "Subnet cidr for Web Applications"
  type        = list(string)
  validation {
    condition     = length(var.web_subnet_cidr) > 0
    error_message = "Must be atleast 1 cidr present"
  }
}

variable "app_subnet_cidr" {
  description = "Subnet cidr for API Services"
  type        = list(string)
  validation {
    condition     = length(var.app_subnet_cidr) > 0
    error_message = "Must be atleast 1 cidr present"
  }
}

variable "privatelink_subnet_cidr" {
  description = "Subnet cidr for Private Endpoints"
  type        = list(string)
  validation {
    condition     = length(var.privatelink_subnet_cidr) > 0
    error_message = "Must be atleast 1 cidr present"
  }
}

variable "app_name" {
  description = "Application Name"
  type        = string
  default     = "challenge"
  validation {
    condition     = length(var.app_name) < 12
    error_message = "Keep Application Name Short And Below 12 Characters"
  }
}

# Use Plans for testing as F1, B1, SHARED, S1 or P1v2
variable "app_service_plan" {
  description = "Sku for App Service Plan"
  type        = string
}

# Use Basic or S1 for testing
variable "sqldb_sku" {
  description = "Sku for SQL Server Database"
  type        = string
}