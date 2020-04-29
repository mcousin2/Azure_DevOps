resource "random_pet" "bastion" {
  length = 2
}

resource "azurerm_public_ip" "bastion" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = format("%s-bastion", var.namespace)
  allocation_method   = "Dynamic"
  domain_name_label   = random_pet.bastion.id
  tags                = var.common_tags
}

resource "azurerm_network_interface" "bastion" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = format("%s-bastion-nic", var.namespace)

  ip_configuration {
    name = "ipconfig"
    # just drop in first subnet - hacky
    subnet_id                     = azurerm_subnet.networking[0].id
    public_ip_address_id          = azurerm_public_ip.bastion.id
    private_ip_address_allocation = "dynamic"
  }
  tags = var.common_tags
}


resource "azurerm_linux_virtual_machine" "bastion" {
  resource_group_name   = var.resource_group_name
  location              = var.location
  name                  = format("%s-bastion-vm", var.namespace)
  network_interface_ids = [azurerm_network_interface.bastion.id]
  size                  = "Standard_D1_v2"
  admin_username        = var.bastion.username

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = var.bastion.username
    public_key = var.bastion.public_key
  }

  tags = var.common_tags
}
