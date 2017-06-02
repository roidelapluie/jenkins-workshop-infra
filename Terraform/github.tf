provider "github" {
  token        = "${var.github_token}"
  organization = "${var.github_organization}"
}

resource "github_repository" "trustedsharedlib" {
  count        = "${length(var.github_usernames)}"
  name         = "${format("trusted%02d", count.index + 1)}"
  description  = "Shared Library to be imported in the Global configuration"
  homepage_url = "https://${format("jenkins%02d", count.index + 1)}.${digitalocean_domain.default.name}"
}

resource "github_repository" "untrustedsharedlib" {
  count       = "${length(var.github_usernames)}"
  name        = "${format("untrusted%02d", count.index + 1)}"
  description = "Shared Library to be imported in the Folder configuration"
}

resource "github_repository_collaborator" "wsuser" {
  count      = "${length(var.github_usernames)}"
  repository = "${element(github_repository.trustedsharedlib.*.name, count.index)}"
  username   = "${element(var.github_usernames, count.index)}"
  permission = "push"
}

resource "github_repository_collaborator" "wsuser2" {
  count      = "${length(var.github_usernames)}"
  repository = "${element(github_repository.untrustedsharedlib.*.name, count.index)}"
  username   = "${element(var.github_usernames, count.index)}"
  permission = "push"
}

output "github-usernames" {
  value = "${zipmap(digitalocean_droplet.jenkins.*.name, github_repository_collaborator.wsuser2.*.username)}"
}
