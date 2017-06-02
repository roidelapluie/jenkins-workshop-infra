resource "digitalocean_floating_ip" "traefik" {
  droplet_id = "${digitalocean_droplet.traefik.id}"
  region     = "${digitalocean_droplet.traefik.region}"
}

resource "digitalocean_record" "jenkins" {
  count  = "${length(var.github_usernames)}"
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "${element(digitalocean_droplet.jenkins.*.name, count.index)}"
  value  = "${digitalocean_floating_ip.traefik.ip_address}"
}

resource "digitalocean_domain" "default" {
  name       = "${var.do_domain}"
  ip_address = "${digitalocean_floating_ip.traefik.ip_address}"
}
