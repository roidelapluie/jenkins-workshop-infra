data "template_file" "consul_bootstrap" {
  template = <<EOF
{
  "bootstrap_expect": ${length(var.github_usernames) == "1" ? "2" : "3"},
  "server": true
}
EOF
}

data "template_file" "consul_bootstrap_agent" {
  template = <<EOF
{
}
EOF
}

data "template_file" "consul_security" {
  template = <<EOF
{"encrypt": "${random_id.consul.b64_std}"}
EOF
}
