variable "count" {}
variable "do_api_token" {}
variable "do_datacenter" {}
variable "do_jenkins_droplet_version" {}
variable "do_traefik_droplet_version" {}
variable "do_domain" {}
variable "do_ssh_key" {}
variable "traefik_userdef" {}

provider "digitalocean" {
  token = "${var.do_api_token}"
}
