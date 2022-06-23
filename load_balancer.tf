resource "azurerm_public_ip" "lb-public-ip" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "load-balancer" {
  name = "TestLoadBalancer"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"

  frontend_ip_configuration {
    name = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb-public-ip.id
  }
}
resource "azurerm_lb_backend_address_pool" "lb-backend" {
  loadbalancer_id = azurerm_lb.load-balancer.id
  name = azurerm_lb.load-balancer.name
}

resource "azurerm_network_interface_backend_address_pool_association" "vm-lb" {
  count = var.machine
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb-backend.id
  ip_configuration_name = azurerm_network_interface.App-network[count.index].ip_configuration[0].name
  network_interface_id = azurerm_network_interface.App-network[count.index].id
}

resource "azurerm_lb_rule" "connect" {
  backend_port = 8080
  frontend_ip_configuration_name = azurerm_lb.load-balancer.frontend_ip_configuration[0].name
  frontend_port = 8080
  loadbalancer_id = azurerm_lb.load-balancer.id
  name = "connect"
  protocol = "Tcp"
  resource_group_name = azurerm_resource_group.rg.name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb-backend.id]
  probe_id = azurerm_lb_probe.check.id
}
resource "azurerm_lb_probe" "check" {
  loadbalancer_id = azurerm_lb.load-balancer.id
  name = "check"
  port = 8080
  resource_group_name = azurerm_resource_group.rg.name
  interval_in_seconds = 6
}