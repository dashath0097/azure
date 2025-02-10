provider "azurerm" {
  features {}
}

# Define variables
variable "resource_group_name" {
  default = "spacelift-rg"  # Change to your existing Resource Group
}

variable "location" {
  default = "East US"
}

variable "vm_name" {
  default = "spacelift-vm"
}

variable "admin_username" {
  default = "azureuser"
}

variable "admin_password" {
  default = "SecureP@ssw0rd!"  # Not recommended for production
}

variable "nic_name" {
  default = "spacelift-nic"  # Replace with existing NIC name
}

variable "public_ip_name" {
  default = "spacelift-public-ip"  # Replace with your existing Public IP name
}

# Reference an existing Network Interface
data "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = var.resource_group_name
}

# Fetch the associated Public IP
data "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = "Standard_B1s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [data.azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Output VM Details
output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

# Corrected Output for Public IP
output "vm_public_ip" {
  value = data.azurerm_public_ip.public_ip.ip_address
}
