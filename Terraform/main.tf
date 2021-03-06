variable "do_api_token" {}

variable "github_usernames" {
  type = "list"
}

variable "do_datacenter" {}
variable "do_jenkins_droplet_version" {}
variable "do_traefik_droplet_version" {}
variable "do_domain" {}
variable "do_ssh_key" {}
variable "traefik_userdef" {}
variable "github_token" {}
variable "github_organization" {}

provider "digitalocean" {
  token = "${var.do_api_token}"
}
