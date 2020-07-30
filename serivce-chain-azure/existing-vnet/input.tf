variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

variable "vm_prefix" {
  type        = "string"
  description = "Name prifix"
}


variable "scn_vm_count" {
  default = 4
}

variable "en_vm_count" {
  default = 1
}

variable "en_vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_D8S_V3"
}

variable "scn_vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_D4S_V3"
}

variable "en_data_disk_size_gb" {
  description = "Storage data disk size"
  default     = "512"
}

variable "scn_data_disk_size_gb" {
  description = "Storage data disk size"
  default     = "64"
}


variable "en_subnet_name" {
  type        = "string"
  description = "en_subnet_name"
}

variable "scn_subnet_name" {
  type        = "string"
  description = "scn_subnet_name"
}

variable "vnet_name" {
  type        = "string"
  description = "vnetnet_name"
}

variable "admin_username" {
  type        = "string"
  description = "account"
}

variable "ssh_key" {
  type        = "string"
  description = "SSH public Key"
}

variable "tags" {
  default = {}
}
