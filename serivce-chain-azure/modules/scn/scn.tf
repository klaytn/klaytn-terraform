provider "azurerm" {
  version   = "=1.28.0"
}


resource "azurerm_network_interface" "scn" {
  count               =  var.scn_vm_count
  name                  = "${var.vm_prefix}-scn-${count.index + 1}-nic"
  location              = "${var.azure_location}"
  resource_group_name   = "${var.azure_resource_group_name}"

  ip_configuration {
    name                          = "${var.vm_prefix}-scn-${count.index + 1}-ip"
    subnet_id                   = "${local.subnet_id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "scn" {
  count                 = var.scn_vm_count
  name                  = "${var.vm_prefix}-scn-${count.index + 1}"
  location              = "${var.azure_location}"
  resource_group_name   = "${var.azure_resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.scn[count.index].id}"]
  vm_size               = "${local.vm_size}"

  tags = merge(var.tags, {
      Name = "${var.vm_prefix}-scn-${count.index + 1}"
     }
     )

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_8"
    version   = "latest"
  }
  
  storage_os_disk {
    name              = "${var.vm_prefix}-scn-${count.index + 1}-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"

  }

  os_profile {
    computer_name  = "${var.vm_prefix}-scn-${count.index + 1}"
    admin_username = "${local.admin}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
          
      ssh_keys {
      path     = "/home/${local.admin}/.ssh/authorized_keys"
      key_data = "${file("${var.ssh_key}")}"
    }
  }
}

  resource "azurerm_managed_disk" "scn-disk" {
  count                =  var.scn_vm_count  
  name                 = "${var.vm_prefix}-scn-${count.index + 1}-data"
  location              = "${var.azure_location}"
  create_option        = "Empty"
  disk_size_gb         = "${var.scn_data_disk_size_gb}"
  resource_group_name  = "${var.azure_resource_group_name}"
  storage_account_type = "Premium_LRS"
  }

    resource "azurerm_virtual_machine_data_disk_attachment" "scn-disk" {
  count              = var.scn_vm_count  
  virtual_machine_id = azurerm_virtual_machine.scn[count.index].id
  managed_disk_id    = azurerm_managed_disk.scn-disk[count.index].id
  lun                = 0
  caching            = "None"
  }
