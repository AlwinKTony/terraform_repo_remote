resource "aws_instance" "local" {
  ami = "ami-02bf8ce06a8ed6092"
    instance_type = "t2.micro"
    key_name = "aws_login"
    tags = {
      Name = "dev-ec2"
    }

}
terraform {
  backend "s3" {
    bucket = "statefile-store"
    key    = "folder-1/terraform.tfstate"
    region = "us-east-2"
  }
}