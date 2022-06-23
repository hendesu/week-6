output "resource_group_name" {
    value = azurerm_resource_group.rg.name
}

output "resource_linux_machine_pass" {
    value = azurerm_linux_virtual_machine.Appserver[*].admin_password
    sensitive = true
}

output "resource_postgresql_flexible_server_pass" {
    value = azurerm_postgresql_flexible_server.postgres-server-for-staging.administrator_password
    sensitive = true
}

output "resource_linux_machine_user" {
    value = azurerm_linux_virtual_machine.Appserver[*].admin_username
    sensitive = true
}

output "resource_postgresql_flexible_server_user" {
    value = azurerm_postgresql_flexible_server.postgres-server-for-staging.administrator_login
    sensitive = true
}

output "public_ip" {
    value = "${azurerm_public_ip.lb-public-ip.*.ip_address}"
}