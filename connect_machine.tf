resource "azurerm_linux_virtual_machine" "main" {
  admin_username = var.main_user
  admin_password = var.main_pass
  location = azurerm_resource_group.rg.location
  name = "main-machine"
  network_interface_ids = [azurerm_network_interface.main-nic.id]
  resource_group_name = azurerm_resource_group.rg.name
  size = "Standard_B1s"
  disable_password_authentication = false


  os_disk {
    name                 = "Disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}
resource "azurerm_network_interface" "main-nic" {
  location = azurerm_resource_group.rg.location
  name = "newww"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name = "new-public"
    subnet_id = azurerm_subnet.new-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public-ip-new.id
  }
}
resource "azurerm_network_security_group" "main-nsg" {
  location = azurerm_resource_group.rg.location
  name = "ns"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    access = "Allow"
    direction = "Inbound"
    name = "all"
    priority = 110
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix  = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "new-merge" {
  network_interface_id = azurerm_network_interface.main-nic.id
  network_security_group_id = azurerm_network_security_group.main-nsg.id
}

resource "azurerm_public_ip" "public-ip-new" {
  allocation_method = "Static"
  location = azurerm_resource_group.rg.location
  name = "public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
}

resource "azurerm_subnet" "new-subnet" {
  name                 = "new-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.5.0/24"]
}
