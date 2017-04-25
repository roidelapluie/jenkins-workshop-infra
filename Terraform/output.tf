output "admin-passwords" {
  value = "${zipmap(digitalocean_droplet.jenkins.*.name, random_id.password.*.hex)}"
}

output "addresses" {
  value = "${zipmap(digitalocean_droplet.jenkins.*.name, digitalocean_droplet.jenkins.*.ipv4_address)}"
}
