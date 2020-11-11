provider "azurerm" {
  version = "=1.28.0"
}


resource "azurerm_resource_group" "resourceGroup" {
  name     = var.azure_rg_name
  location = var.azure_location
}

module "azure_virtual_network" {
  source                    = "./modules/azure_virtual_network"
  vm_prefix                 = var.name_prifix
  azure_location            = var.azure_location
  azure_resource_group_name = "${azurerm_resource_group.resourceGroup.name}"
}

module "en_vm" {
  source                    = "./modules/en"
  vm_prefix                 = var.name_prifix
  azure_location            = var.azure_location
  azure_resource_group_name = "${azurerm_resource_group.resourceGroup.name}"
  azure_subnet_id           = "${module.azure_virtual_network.en_subnet_id}"
}

module "scn_vm" {
  source                    = "./modules/scn"
  vm_prefix                 = var.name_prifix
  azure_location            = var.azure_location
  azure_resource_group_name = "${azurerm_resource_group.resourceGroup.name}"
  azure_subnet_id           = "${module.azure_virtual_network.scn_subnet_id}"
}