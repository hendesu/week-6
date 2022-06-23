

resource "azurerm_subnet" "Database-subnet" {
  name                 = "private-ps-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.6.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "affs"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }

}

resource "azurerm_network_security_group" "Database-nsg" {
  location = azurerm_resource_group.rg.location
  name = "Database-app-nsg"
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
    destination_port_range     = 5432
    source_address_prefix      = "10.0.0.0/16"
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

resource "azurerm_subnet_network_security_group_association" "merge" {
  network_security_group_id = azurerm_network_security_group.Database-nsg.id
  subnet_id = azurerm_subnet.Database-subnet.id

}

resource "azurerm_private_dns_zone" "db-dns" {
  name                = "db.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [azurerm_subnet_network_security_group_association.merge]
}