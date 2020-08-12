variable "azure_location" {
  type        = "string"
  description = "Azure location"
}

variable "vm_prefix" {
  type        = "string"
  description = "Name prifix"
}

variable "azure_resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

variable "azure_vnet_cidr" {
  type        = "string"
  description = "vnetnet_cidr"
  default     = "[Vnet CIDR]" // Example : "10.0.0.0/16"
}

variable "en_subnet_cidr" {
  type        = "string"
  description = "subnet_cidr"
  default     = "[subnet CIDR]" // Example : "10.0.0.0/24"
}

variable "scn_subnet_cidr" {
  type        = "string"
  description = "subnet_cidr"
  default     = "[subnet CIDR]" // Example : "10.0.1.0/24"
}

locals {
  vnet_cidr       = var.azure_vnet_cidr
  en_subnet_cidr  = var.en_subnet_cidr
  scn_subnet_cidr = var.scn_subnet_cidr
}