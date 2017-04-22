data "digitalocean_image" "jenkins" {
  name = "jenkins-${var.do_jenkins_droplet_version}"
}

data "digitalocean_image" "traefik" {
  name = "traefik-${var.do_traefik_droplet_version}"
}
