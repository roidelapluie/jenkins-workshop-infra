data "template_file" "consul_bootstrap" {
  template = <<EOF
{
  "bootstrap_expect": ${var.count == "1" ? "2" : "3"},
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
