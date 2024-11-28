resource "local_sensitive_file" "foo" {
  content  = "foo!"
  filename = "${path.module}/foo.bar"
  file_permission = "775"
}