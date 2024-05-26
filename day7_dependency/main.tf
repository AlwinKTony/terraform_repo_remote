resource "aws_instance" "dependencyblock" {
  ami = "ami-02bf8ce06a8ed6092"
  instance_type = "t2.micro"
  key_name = "aws_login"
  tags ={
  Name = "dependency"  
}
}
resource "aws_s3_bucket" "dependencybucket" {
  bucket = "dependency-s3-blockpractice"
  depends_on = [ aws_instance.dependencyblock ]
}
 