resource "random_id" "password" {
  count = "${length(var.github_usernames)}"

  keepers = {
    id = "${count.index}"
  }

  byte_length = 4
}

resource "random_id" "consul" {
  byte_length = 16
}
