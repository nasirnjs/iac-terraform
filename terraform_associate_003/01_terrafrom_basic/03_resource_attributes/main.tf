# First file: Write some content to a local file
resource "local_file" "first_file" {
  filename = "first_file.txt"
  content  = "Hello, this is the content of the first file."
}

# Second file: Use the content of the first file in a new file
resource "local_file" "second_file" {
  filename = "second_file.txt"
  content  = "The first file says: ${local_file.first_file.content}"
}
