resource "digitalocean_droplet" "ctf_nodes" {
  count  = var.vm_count
  name   = "ctf-node-${count.index}"
  region = var.region
  size   = var.droplet_size
  image  = "ubuntu-22-04-x64"

  ssh_keys = [var.ssh_key_fingerprint]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io git
              systemctl enable docker
              systemctl start docker
              git clone https://github.com/elankumuthan/challenge_box.git /opt/ctf
              cd /opt/ctf
              docker build -t ctf_sqli_xss .
              docker run -d -p 80:80 ctf_sqli_xss
              EOF
}

output "ctf_instance_ips" {
  value = digitalocean_droplet.ctf_nodes[*].ipv4_address
}
