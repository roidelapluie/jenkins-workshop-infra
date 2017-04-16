resource "digitalocean_droplet" "traefik" {
  image = "${data.external.traefik_snapshot.result.id}"
  name = "traefik"
  ssh_keys = [ "${var.do_ssh_key}" ]
  region = "${var.do_datacenter}"
  private_networking = "true",
  size = "512mb"

  provisioner "file" {
    content     = <<EOF
${file("traefik.toml")}
[consulCatalog]
endpoint = "127.0.0.1:8500"
prefix = "traefik"
EOF
    destination = "/etc/traefik.toml"
  }

  provisioner "file" {
    content     = <<EOF
{
  "bind_addr": "${self.ipv4_address_private}",
  "data_dir": "/etc/consul"
}
EOF
    destination = "/etc/consul.json"
  }

  provisioner "file" {
    content     = "${data.template_file.consul_bootstrap.rendered}",
    destination = "/etc/consul.d/bootstrap.json"
  }


  provisioner "file" {
    source     = "../certs"
    destination = "/etc/traefik-ssl"
  }


  provisioner "remote-exec" {
    inline = [
        "systemctl start consul",
        "systemctl enable consul",
        "systemctl start traefik",
        "systemctl enable traefik",
    ]
  }
}

