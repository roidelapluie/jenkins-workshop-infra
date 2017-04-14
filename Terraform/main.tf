variable "count" {}
variable "do_api_token" {}
variable "do_datacenter" {}
variable "do_deploy_jenkins_image" {}
variable "do_deploy_traefik_image" {}
variable "do_domain" {}
variable "do_ssh_key" {}

provider "digitalocean" {
  token = "${var.do_api_token}"
}

resource "digitalocean_domain" "default" {
  name       = "${var.do_domain}"
  ip_address = "${digitalocean_floating_ip.traefik.ip_address}"
}

resource "random_id" "password" {
  count  = "${var.count}"
  keepers = {
    id= "${count.index}"
  }
  byte_length = 4
}

resource "digitalocean_droplet" "jenkins" {
  count  = "${var.count}"
  image = "${var.do_deploy_jenkins_image}"
  name = "${format("jenkins%02d", count.index + 1)}"
  ssh_keys = [ "${var.do_ssh_key}" ]
  region = "${var.do_datacenter}"
  private_networking = "true",
  size = "512mb"
  provisioner "remote-exec" {
    inline = [
        "echo -n ${element(random_id.password.*.hex, count.index)} | su --shell=/bin/bash jenkins -c 'tee /tmp/password >/dev/null'",
        "service jenkins restart"
    ]
  }
}

data "template_file" "traefik_backend" {
    count = "${var.count}"
    template = "${file("backend.tpl")}"
    vars {
      name   = "${element(digitalocean_droplet.jenkins.*.name, count.index)}"
      private_ip   = "${element(digitalocean_droplet.jenkins.*.ipv4_address_private, count.index)}"
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
      name   = "${element(digitalocean_droplet.jenkins.*.name, count.index)}"
      domain = "${var.do_domain}"
    }
}

resource "digitalocean_floating_ip" "traefik" {
  droplet_id = "${digitalocean_droplet.traefik.id}"
  region     = "${digitalocean_droplet.traefik.region}"
}

resource "digitalocean_record" "jenkins" {
  count  = "${var.count}"
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "${element(digitalocean_droplet.jenkins.*.name, count.index)}"
  value  = "${digitalocean_floating_ip.traefik.ip_address}"
}

resource "digitalocean_droplet" "traefik" {
  image = "${var.do_deploy_traefik_image}"
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
    source     = "../certs"
    destination = "/etc/traefik-ssl"
  }


  provisioner "remote-exec" {
    inline = [
        "systemctl start traefik",
    ]
  }
}

output "addresses-passwords" {
    value = "${zipmap(digitalocean_droplet.jenkins.*.name, random_id.password.*.hex)}"
}
