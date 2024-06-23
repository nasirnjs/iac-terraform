terraform {
  required_providers {
    ssh = {
      source = "loafoe/ssh"
      version = "2.7.0"
    }
  }
}

variable "ssh_user" {
  description = "SSH username for authenticating to the remote host"
}

variable "ssh_password" {
  description = "SSH password for authenticating to the remote host"
}

resource "ssh_resource" "execute_command" {
  host     = "172.17.18.193"
  user     = var.ssh_user     
  password = var.ssh_password

  commands = [
    "hostname > /tmp/host_machine-name.txt"
  ]
}


/*
Defines the required_providers block where you specify that your configuration requires the ssh provider from the source loafoe/ssh at version 2.7.0.
This instructs Terraform to download and use this specific provider version.
*/