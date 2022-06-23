
resource "azurerm_network_interface" "App-network" {
  count               = var.machine
  name                = "app-nic${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "public"
    subnet_id = azurerm_subnet.App-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_subnet" "App-subnet" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "App-nsg" {
  location = azurerm_resource_group.rg.location
  name = "server-app-nsg"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "http"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 8080
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "all"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "merge-app" {
  network_security_group_id = azurerm_network_security_group.App-nsg.id
  subnet_id = azurerm_subnet.App-subnet.id

}