provider "azurerm" {
  version = "=1.28.0"
}

resource "azurerm_virtual_network" "VirtualNetwork" {
  name                = "${var.vm_prefix}-vNet"
  location            = var.azure_location
  resource_group_name = var.azure_resource_group_name
  address_space       = ["${local.vnet_cidr}"]
}

resource "azurerm_subnet" "en" {
  name                 = "${var.vm_prefix}-en-Subnet"
  resource_group_name  = var.azure_resource_group_name
  virtual_network_name = "${azurerm_virtual_network.VirtualNetwork.name}"
  address_prefix       = "${local.en_subnet_cidr}"
}
resource "azurerm_subnet" "scn" {
  name                 = "${var.vm_prefix}-scn-Subnet"
  resource_group_name  = var.azure_resource_group_name
  virtual_network_name = "${azurerm_virtual_network.VirtualNetwork.name}"
  address_prefix       = "${local.scn_subnet_cidr}"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_network_security_group" "en" {
  name                = "${var.vm_prefix}-en-NSG"
  location            = var.azure_location
  resource_group_name = var.azure_resource_group_name
}

resource "azurerm_network_security_rule" "en-ssh" {
  name                        = "ssh"
  resource_group_name         = var.azure_resource_group_name
  description                 = "Allow remote protocol in from all locations"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 22
  source_address_prefix       = "${chomp(data.http.myip.body)}/32"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.en.name
}

resource "azurerm_network_security_rule" "en-klaytn-tcp1" {
  name                        = "klatn-tcp1"
  resource_group_name         = var.azure_resource_group_name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 110
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "${azurerm_subnet.scn.address_prefix}"
  destination_port_range      = "50505"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.en.name
}

resource "azurerm_network_security_rule" "en-klaytn-tcp2" {
  name                        = "klatn-tcp2"
  resource_group_name         = var.azure_resource_group_name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 120
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "${azurerm_subnet.scn.address_prefix}"
  destination_port_range      = "32323-32324"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.en.name
}

resource "azurerm_subnet_network_security_group_association" "en" {
  subnet_id                 = azurerm_subnet.en.id
  network_security_group_id = azurerm_network_security_group.en.id
}


resource "azurerm_network_security_group" "scn" {
  name                = "${var.vm_prefix}-scn-NSG"
  location            = var.azure_location
  resource_group_name = var.azure_resource_group_name
}

resource "azurerm_network_security_rule" "scn-ssh" {
  name                        = "ssh"
  resource_group_name         = var.azure_resource_group_name
  description                 = "Allow remote protocol in from all locations"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 22
  source_address_prefix       = "${azurerm_subnet.en.address_prefix}"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.scn.name
}

resource "azurerm_network_security_rule" "scn-klaytn-tcp1" {
  name                        = "klatn-tcp1"
  resource_group_name         = var.azure_resource_group_name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 110
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "${azurerm_subnet.en.address_prefix}"
  destination_port_range      = "50505"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.scn.name
}

resource "azurerm_network_security_rule" "scn-klaytn-tcp2" {
  name                        = "klatn-tcp2"
  resource_group_name         = var.azure_resource_group_name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 120
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "${azurerm_subnet.en.address_prefix}"
  destination_port_range      = "32323-32324"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.scn.name
}

resource "azurerm_subnet_network_security_group_association" "scn" {
  subnet_id                 = azurerm_subnet.scn.id
  network_security_group_id = azurerm_network_security_group.scn.id
}