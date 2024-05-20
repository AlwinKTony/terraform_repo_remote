provider "aws" {
  region = "us-east-2"
}
resource "aws_instance" "test" {
    ami = "ami-02bf8ce06a8ed6092"
    instance_type = "t2.micro"
    availability_zone = "us-east-2b"
    # subnet_id = "subnet-0a509e41d91a981ec"
    key_name = "aws_login"
    
  tags = {
    Name = "lifecycle_rules_instance"
  }




#below examples are for lifecycle meta_arguments 

#   lifecycle {
#     create_before_destroy = true    #this attribute will create the new object first and then destroy the old one
#   }

# lifecycle {
#   prevent_destroy = true    #Terraform will error when it attempts to destroy a resource when this is set to true:
# }


#   lifecycle {
#     ignore_changes = [tags,] #This means that Terraform will never update the object but will be able to create or destroy it.
#   }

}