resource "aws_instance" "local" {
  ami = "ami-02bf8ce06a8ed6092"
 instance_type ="t2.micro"
 key_name = "aws_login"
 user_data = file("test.sh")
    tags = {
      Name = "dev-ec2"
    }

}