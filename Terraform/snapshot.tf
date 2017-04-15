data "external" "jenkins_snapshot" {
  program = ["./do_snapshot_id"]
  query {
    id = "jenkins-${var.do_jenkins_droplet_version}"
    api_token = "${var.do_api_token}"
  }
}
data "external" "traefik_snapshot" {
  program = ["./do_snapshot_id"]
  query {
    id = "traefik-${var.do_traefik_droplet_version}"
    api_token = "${var.do_api_token}"
  }
}
