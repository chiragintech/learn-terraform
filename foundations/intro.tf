# comment

# block_type "block_label" "block_label" {
#     first_argument = expression or value
#     second_argument = expression or value
#     third_argument = expression or value
# }

# attribute_abc = "value_1"
# attribute_2 = "value_2"

# Retrieve the list of AZs in the current AWS region
# data blocks - no params
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

# Define the VPC
# resource block
# <type of block> "<resource type>" "<name>"
# resource types are defined in providers
# name is an unique identifier
resource "aws_vpc" "vpc" { # we use underscores - snake cases as default style !
    # arguments - some type of value, under block
    # cidr_block = var.vpc_cidr
    # 2 spaces identation
    # alignment of equal signs
    tags = {
        # Name        = var.vpc_name
        Environment = "demo_environment"
        Terraform   = "true"
    }
}
# Blocks have named values - terraform can access info created by or obtained by a block
# we use resource type and name to identify - aws_vpc.vpc