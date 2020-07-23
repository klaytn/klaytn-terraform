variable "azure_location" {
  type          = "string"
  description   = "Azure location"
}

variable "vm_prefix" {
  type          = "string"
  description   = "Name prifix"
}

variable "scn_vm_count" {
  default = 4
}

variable "azure_resource_group_name" {
  type          = "string"
  description   = "Resource group name"
}

variable "azure_subnet_id" {
  type          = "string"
  description   = "Subnet ID"
}

variable "azure_virtual_machine_size" {
  type          = "string"
  description   = "virtual machine size"
  default       = "Standard_D4s_V3"
}

variable "azure_vmadmin_account" {
  type          = "string"
  description   = "account"
  default       = "[admin account]"  // Example : "vmadmin"
}

variable "ssh_key" {
  type          = "string"
  description   = "SSH public Key"
  default       = "~/.ssh/id_rsa.pub"
}

variable "scn_data_disk_size_gb" {
  description = "Storage data disk size"
  default     = "64"
}

variable "tags" {
  type = map
  default = {
  Terraform   = "true"
  Team        = "[team name]"  // Example : "devops"
  Environment = "dev"
  Project     = "[project name]"  // Example : "klaytn"
  }
}

locals {
  subnet_id             = "${var.azure_subnet_id}"
  vm_size               = "${var.azure_virtual_machine_size}"
  admin                 = "${var.azure_vmadmin_account}"
  ssh_key               = "${var.ssh_key}"
}