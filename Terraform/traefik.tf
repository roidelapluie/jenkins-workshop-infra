data "template_file" "traefik_backend" {
    count = "${var.count}"
    template = "${file("backend.tpl")}"
    vars {
      domain = "${var.do_domain}"
    }
}

data "template_file" "traefik_config" {
    template = "${file("traefik.toml")}[file]\n[frontends]\n$${frontend}\n[backends]\n$${backend}"
    vars {
        backend = "${join("\n", data.template_file.traefik_backend.*.rendered)}"
        frontend = "${join("\n", data.template_file.traefik_frontend.*.rendered)}"
    }
}

data "template_file" "traefik_frontend" {
    count = "${var.count}"
    template = "${file("frontend.tpl")}"
    vars {
      domain = "${var.do_domain}"
    }
}

resource "digitalocean_droplet" "traefik" {
  image = "${data.external.traefik_snapshot.result.id}"
  name = "traefik"
  ssh_keys = [ "${var.do_ssh_key}" ]
  region = "${var.do_datacenter}"
  private_networking = "true",
  size = "512mb"

  provisioner "file" {
    content     = "${data.template_file.traefik_config.rendered}"
    destination = "/etc/traefik.toml"
  }

  provisioner "file" {
    content     = "{\"bind_addr\": \"${self.ipv4_address_private}\", \"data_dir\": \"/etc/consul\"}"
    destination = "/etc/consul.json"
  }

  provisioner "file" {
    source     = "../certs"
    destination = "/etc/traefik-ssl"
  }


  provisioner "remote-exec" {
    inline = [
        "systemctl start consul",
        "systemctl enable consul",
        #"systemctl start traefik",
    ]
  }
}

