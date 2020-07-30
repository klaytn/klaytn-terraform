# refer to a resource group
data "azurerm_resource_group" "en" {
  name = var.resource_group_name
}

#refer to a subnet
data "azurerm_subnet" "en" {
  name                 = "${var.en_subnet_name}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.resource_group_name}"
}

# Create public IPs
resource "azurerm_public_ip" "en-pip" {
  count               = var.en_vm_count
  name                = "${var.vm_prefix}-en-${count.index + 1}-pip"
  location            = "${data.azurerm_resource_group.en.location}"
  resource_group_name = "${data.azurerm_resource_group.en.name}"
  allocation_method   = "Static"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# create a network interface
resource "azurerm_network_interface" "en" {
  count               = var.en_vm_count
  name                = "${var.vm_prefix}-en-${count.index + 1}-nic"
  location            = "${data.azurerm_resource_group.en.location}"
  resource_group_name = "${data.azurerm_resource_group.en.name}"

  ip_configuration {
    name                          = "${var.vm_prefix}-en-${count.index + 1}-ip"
    subnet_id                     = "${data.azurerm_subnet.en.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.en-pip[count.index].id}"
  }
}

resource "azurerm_network_security_group" "en" {
  name                = "${var.vm_prefix}-en-NSG"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"
}

resource "azurerm_network_security_rule" "en-ssh" {
  name                        = "ssh"
  resource_group_name         = "${var.azure_resource_group_name}"
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
  resource_group_name         = "${var.azure_resource_group_name}"
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
  resource_group_name         = "${var.azure_resource_group_name}"
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

resource "azurerm_network_interface_security_group_association" "en" {
  count                     = var.en_vm_count
  network_interface_id      = "${azurerm_network_interface.en[count.index].id}"
  network_security_group_id = azurerm_network_security_group.en.id
}

# Create virtual machine
resource "azurerm_virtual_machine" "en" {
  count                 = var.en_vm_count
  name                  = "${var.vm_prefix}-en-${count.index + 1}"
  location              = "${azurerm_network_interface.en[count.index].location}"
  resource_group_name   = "${data.azurerm_resource_group.en.name}"
  network_interface_ids = ["${azurerm_network_interface.en[count.index].id}"]
  vm_size               = var.en_vm_size
  tags = merge(var.tags, {
    Name = "${var.vm_prefix}-en-${count.index + 1}"
    }
  )

  os_profile {
    computer_name  = "${var.vm_prefix}-en-${count.index + 1}"
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
    name              = "${var.vm_prefix}-en-${count.index + 1}-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
}
resource "azurerm_managed_disk" "en" {
  count                = var.en_vm_count
  name                 = "${var.vm_prefix}-en-${count.index + 1}-data"
  location             = "${data.azurerm_resource_group.en.location}"
  create_option        = "Empty"
  disk_size_gb         = "${var.en_data_disk_size_gb}"
  resource_group_name  = "${data.azurerm_resource_group.en.name}"
  storage_account_type = "Premium_LRS"
}

resource "azurerm_virtual_machine_data_disk_attachment" "en" {
  count              = var.en_vm_count
  virtual_machine_id = azurerm_virtual_machine.en[count.index].id
  managed_disk_id    = azurerm_managed_disk.en[count.index].id
  lun                = 0
  caching            = "None"
}
