variable "filename" {
  description = "File location for the local file resource"
}

variable "prefix" {
  description = "Prefix for generating random pet name"
}

variable "separator" {
  description = "Separator for generating random pet name"
}

variable "length" {
  description = "Length of the random pet name"
}

resource "local_file" "pet" {
  filename = var.filename
  content  = "My favorite pet is ${random_pet.my-pet.id}" # Example of Implicit Dependency
  
  # Explicit dependency: local_file.pet depends on random_pet.my-pet
  # depends_on = [random_pet.my-pet]
}

resource "random_pet" "my-pet" {
  prefix    = var.prefix
  separator = var.separator
  length    = var.length
}

output "pet_name" {
  value = random_pet.my-pet.id
}