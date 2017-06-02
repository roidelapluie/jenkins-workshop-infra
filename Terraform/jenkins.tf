resource "digitalocean_droplet" "jenkins" {
  count              = "${length(var.github_usernames)}"
  name               = "${format("jenkins%02d", count.index + 1)}"
  image              = "${data.digitalocean_image.jenkins.image}"
  ssh_keys           = ["${var.do_ssh_key}"]
  region             = "${var.do_datacenter}"
  private_networking = "true"
  size               = "512mb"

  provisioner "file" {
    content = <<EOF
{
  "bind_addr": "${self.ipv4_address_private}",
  "retry_join":
  [
    "${digitalocean_droplet.traefik.ipv4_address_private}"
  ],
  "data_dir": "/var/lib/consul"
}
EOF

    destination = "/etc/consul.d/consul.json"
  }

  provisioner "file" {
    content     = "${count.index < 2 ? data.template_file.consul_bootstrap.rendered : data.template_file.consul_bootstrap_agent.rendered}"
    destination = "/etc/consul.d/bootstrap.json"
  }

  provisioner "file" {
    content     = "${data.template_file.consul_security.rendered}"
    destination = "/etc/consul.d/encryption.json"
  }

  provisioner "file" {
    content = <<EOF
{
  "service": {
    "name": "${format("jenkins%02d", count.index + 1)}",
    "tags": [
        "traefik.frontend.rule=Host:${self.name}.${var.do_domain}",
        "traefik.frontend.passHostHeader=true"
    ],
    "port": 8080,
    "enableTagOverride": false,
    "address": "${self.ipv4_address_private}"
  }
}
EOF

    destination = "/etc/consul.d/jenkins.json"
  }

  provisioner "remote-exec" {
    inline = [
      "chown -R consul: /etc/consul.d",
      "chmod -R o-rwx /etc/consul.d",
      "systemctl start consul",
      "systemctl enable consul",
      "echo -n ${element(random_id.password.*.hex, count.index)} | su --shell=/bin/bash jenkins -c 'tee /tmp/password >/dev/null'",
      "service jenkins restart",
    ]
  }
}
