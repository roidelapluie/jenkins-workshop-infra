resource "digitalocean_droplet" "jenkins" {
  count  = "${var.count}"
  name = "${format("jenkins%02d", count.index + 1)}"
  image = "${data.external.jenkins_snapshot.result.id}"
  ssh_keys = [ "${var.do_ssh_key}" ]
  region = "${var.do_datacenter}"
  private_networking = "true",
  size = "512mb"

  provisioner "file" {
    content     = "{\"bind_addr\": \"${self.ipv4_address_private}\", \"retry_connect\": \"${digitalocean_droplet.traefik.ipv4_address_private}\", \"data_dir\": \"/etc/consul\"}"
    destination = "/etc/consul.json"
  }

  provisioner "remote-exec" {
    inline = [
        "systemctl start consul",
        "systemctl enable consul",
        "echo -n ${element(random_id.password.*.hex, count.index)} | su --shell=/bin/bash jenkins -c 'tee /tmp/password >/dev/null'",
        "service jenkins restart"
    ]
  }
}

