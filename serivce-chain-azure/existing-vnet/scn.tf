# refer to a resource group
data "azurerm_resource_group" "scn" {
  name = "${var.resource_group_name}"
}

#refer to a subnet
data "azurerm_subnet" "scn" {
  name                 = "${var.scn_subnet_name}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.resource_group_name}"
}

# create a network interface

resource "azurerm_network_interface" "scn" {
  count               = var.scn_vm_count
  name                = "${var.vm_prefix}-scn-${count.index + 1}-nic"
  location            = "${data.azurerm_resource_group.scn.location}"
  resource_group_name = "${data.azurerm_resource_group.scn.name}"

  ip_configuration {
    name                          = "${var.vm_prefix}-scn-${count.index + 1}-ip"
    subnet_id                     = "${data.azurerm_subnet.scn.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_subnet_network_security_group_association" "en" {
  subnet_id                 = azurerm_subnet.en.id
  network_security_group_id = azurerm_network_security_group.en.id
}


resource "azurerm_network_security_group" "scn" {
  name                = "${var.vm_prefix}-scn-NSG"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"
}

resource "azurerm_network_security_rule" "scn-ssh" {
  name                        = "ssh"
  resource_group_name         = "${var.azure_resource_group_name}"
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
  resource_group_name         = "${var.azure_resource_group_name}"
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
  resource_group_name         = "${var.azure_resource_group_name}"
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

resource "azurerm_network_interface_security_group_association" "scn" {
  count                     = var.scn_vm_count
  network_interface_id      = "${azurerm_network_interface.scn[count.index].id}"
  network_security_group_id = azurerm_network_security_group.scn.id
}


# Create virtual machine
resource "azurerm_virtual_machine" "scn" {
  count                 = var.scn_vm_count
  name                  = "${var.vm_prefix}-scn-${count.index + 1}"
  location              = "${azurerm_network_interface.scn[count.index].location}"
  resource_group_name   = "${data.azurerm_resource_group.scn.name}"
  network_interface_ids = ["${azurerm_network_interface.scn[count.index].id}"]
  vm_size               = var.scn_vm_size
  tags = merge(var.tags, {
    Name = "${var.vm_prefix}-scn-${count.index + 1}"
    }
  )

  os_profile {
    computer_name  = "${var.vm_prefix}-scn-${count.index + 1}"
    admin_username = "${var.admin_username}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${file("${var.ssh_key}")}"
    }
  }

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_8"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm_prefix}-scn-${count.index + 1}-os"
    disk_size_gb      = "${var.scn_data_disk_size_gb}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
}
resource "azurerm_managed_disk" "scn" {
  count                = var.scn_vm_count
  name                 = "${var.vm_prefix}-scn-${count.index + 1}-data"
  location             = "${data.azurerm_resource_group.scn.location}"
  create_option        = "Empty"
  disk_size_gb         = "${var.scn_data_disk_size_gb}"
  resource_group_name  = "${data.azurerm_resource_group.scn.name}"
  storage_account_type = "Premium_LRS"
}

resource "azurerm_virtual_machine_data_disk_attachment" "scn" {
  count              = var.scn_vm_count
  virtual_machine_id = azurerm_virtual_machine.scn[count.index].id
  managed_disk_id    = azurerm_managed_disk.scn[count.index].id
  lun                = 0
  caching            = "None"

}

