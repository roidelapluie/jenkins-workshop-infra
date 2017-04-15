resource "random_id" "password" {
  count  = "${var.count}"
  keepers = {
    id= "${count.index}"
  }
  byte_length = 4
}
