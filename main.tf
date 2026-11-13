# resource "azurerm_resource_group" "example" {
#     name     = "example"
#     location = "East Us"
# }

provider "random" {}

variable "num_of_pets" {
    type = number
    description = "how many pets do you want"
}
resource "random_pet" "name" {
  length = var.num_of_pets
}

resource "random_pet" "my_pet" {
  length = 3
}

output "random_pet_name" {
  value = random_pet.name.id
}