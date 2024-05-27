resource "aws_instance" "local-instance" {
  ami="ami-02bf8ce06a8ed6092"
  instance_type = "t2.micro"
  key_name = "aws_login"
  tags = {
    Name= "tag"
  }
}
resource "aws_s3_bucket" "name" {
    bucket = "alwinkulangaratony"
  
}
#terraform plan -target=aws_s3_bucket.name ----command for specfic target to be implemented in between two targets
##terraform apply -target=aws_s3_bucket.name ----command for specfic target to be implemented in between two targets
# similar for destroy