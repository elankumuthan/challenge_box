resource "azurerm_resource_group" "ctf" {
  name     = "ctf-rg"
  location = var.location
}

resource "azurerm_virtual_network" "ctf" {
  name                = "ctf-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ctf.location
  resource_group_name = azurerm_resource_group.ctf.name
}

resource "azurerm_subnet" "ctf" {
  name                 = "ctf-subnet"
  resource_group_name  = azurerm_resource_group.ctf.name
  virtual_network_name = azurerm_virtual_network.ctf.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "ctf" {
  name                = "ctf-nsg"
  location            = azurerm_resource_group.ctf.location
  resource_group_name = azurerm_resource_group.ctf.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "ctf" {
  count               = var.vm_count
  name                = "ctf-ip-${count.index}"
  location            = azurerm_resource_group.ctf.location
  resource_group_name = azurerm_resource_group.ctf.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ctf" {
  count               = var.vm_count
  name                = "ctf-nic-${count.index}"
  location            = azurerm_resource_group.ctf.location
  resource_group_name = azurerm_resource_group.ctf.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ctf.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ctf[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "ctf" {
  count               = var.vm_count
  name                = "ctf-vm-${count.index}"
  resource_group_name = azurerm_resource_group.ctf.name
  location            = azurerm_resource_group.ctf.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.ctf[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io git
              systemctl enable docker
              systemctl start docker
              git clone https://github.com/YOUR_GITHUB/ctf_sqli_xss.git /opt/ctf
              cd /opt/ctf
              docker build -t ctf_sqli_xss .
              docker run -d -p 80:80 ctf_sqli_xss
              EOF
  )
}

output "ctf_vm_ips" {
  value = azurerm_public_ip.ctf[*].ip_address
}
