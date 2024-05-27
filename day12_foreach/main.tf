variable "ami" {
  type    = string
  default = "ami-02bf8ce06a8ed6092"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "sandboxes" {
  type    = list(string)
  default = ["dev","prod","test"]
}


resource "aws_instance" "sandbox" {
  ami           = var.ami
  instance_type = var.instance_type
  for_each      = toset(var.sandboxes)
  #here firstly, dev comes and then prod comes and lastly test comes in.
#   count = length(var.sandboxes)
  tags = {
    Name = each.value # for a set, each.value and each.key is the same
    #in tags each.value dev, prod and and test comes in each by each
  }
#   tags = {
#     Name = var.sandboxes[count.index] # example for count
#   }
} 
