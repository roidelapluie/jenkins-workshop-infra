output "admin-passwords" {
  value = "${zipmap(digitalocean_droplet.jenkins.*.name, random_id.password.*.hex)}"
}

resource "local_file" "foo" {
  count = "${length(var.github_usernames)}"

  content = <<EOF
https://${format("jenkins%02d", count.index + 1)}.${var.do_domain} admin ${element(github_repository_collaborator.wsuser2.*.username, count.index) == "jenkinswsuser" ? element(random_id.password.*.hex, count.index) : element(github_repository_collaborator.wsuser2.*.username, count.index)}
EOF

  filename = "info/${format("jenkins%02d", count.index + 1)}"
}

resource "local_file" "mail" {
  count = "${length(var.github_usernames)}"

  content = <<EOF
Thank you!

I've created you a Jenkins instance for my workshop. You can login at:

https://${format("jenkins%02d", count.index + 1)}.${var.do_domain}
The username is admin and the password is your github account: ${element(github_repository_collaborator.wsuser2.*.username, count.index) == "jenkinswsuser" ? element(random_id.password.*.hex, count.index) : element(github_repository_collaborator.wsuser2.*.username, count.index)}

Please also accept invitations at
https://github.com/jenkinsws/${format("trusted%02d", count.index + 1)}/invitations
https://github.com/jenkinsws/${format("untrusted%02d", count.index + 1)}/invitations

We will do the demo using the github web interface and the provided Jenkins instance.

If you have any problem logging in or you do not have Github invitations,
please reply to this email.

EOF

  filename = "info/${format("mail%02d", count.index + 1)}"
}

output "addresses" {
  value = "${zipmap(digitalocean_droplet.jenkins.*.name, digitalocean_droplet.jenkins.*.ipv4_address)}"
}
