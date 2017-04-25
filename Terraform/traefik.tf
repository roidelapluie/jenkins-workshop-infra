data "template_file" "traefik_web" {
  template = "${file("traefik_web.toml")}"

  vars {
    userdef = "${var.traefik_userdef}"
  }
}

resource "digitalocean_droplet" "traefik" {
  image              = "${data.digitalocean_image.traefik.image}"
  name               = "traefik"
  ssh_keys           = ["${var.do_ssh_key}"]
  region             = "${var.do_datacenter}"
  private_networking = "true"
  size               = "512mb"

  provisioner "file" {
    content = <<EOF
${file("traefik.toml")}
${data.template_file.traefik_web.rendered}
[consulCatalog]
endpoint = "127.0.0.1:8500"
prefix = "traefik"
EOF

    destination = "/etc/traefik.toml"
  }

  provisioner "file" {
    content = <<EOF
{
  "bind_addr": "${self.ipv4_address_private}",
  "data_dir": "/var/lib/consul"
}
EOF

    destination = "/etc/consul.d/consul.json"
  }

  provisioner "file" {
    content     = "${data.template_file.consul_security.rendered}"
    destination = "/etc/consul.d/encryption.json"
  }

  provisioner "file" {
    content     = "${data.template_file.consul_bootstrap.rendered}"
    destination = "/etc/consul.d/bootstrap.json"
  }

  provisioner "file" {
    source      = "../certs"
    destination = "/etc/traefik-ssl"
  }

  provisioner "remote-exec" {
    inline = [
      "chown -R consul: /etc/consul.d",
      "chmod -R o-rwx /etc/consul.d",
      "systemctl start consul",
      "systemctl enable consul",
      "systemctl start traefik",
      "systemctl enable traefik",
    ]
  }
}
