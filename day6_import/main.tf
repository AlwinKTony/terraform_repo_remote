resource "aws_instance" "import" {
  ami = "ami-02bf8ce06a8ed6092"
  instance_type = "t2.micro"
  key_name = "aws_login"
  tags = {
    Name = "my_terraform_practice"
  }
}
