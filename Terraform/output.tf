output "addresses-passwords" {
    value = "${zipmap(digitalocean_droplet.jenkins.*.name, random_id.password.*.hex)}"
}
