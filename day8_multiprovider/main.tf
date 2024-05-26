# Provider-1 for us-east-1 (Default Provider)
provider "aws" {
  region = "ap-south-1"
}

#Another provider alias 
provider "aws" {
  region = "us-east-1"
  alias = "america"
}
#this will be created in the default provider
resource "aws_s3_bucket" "test" {
  bucket = "del-hyd-naresh-it"

}
#this resource will be created in the provider with alias mentioned
resource "aws_s3_bucket" "test2" {
  bucket = "del-hyd-naresh-it-test2"
  provider = aws.america  #provider.value of alias
  depends_on = [ aws_s3_bucket.test ]# so, here tset bucket will be created first and later test2 bucket will be creaetd
  
}