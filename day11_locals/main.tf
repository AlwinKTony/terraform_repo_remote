locals {
  bucket-name = "${var.layer}-${var.env}-bucket-hydnaresh-${var.region}"
  #bucket-name = "development-dev-bucket-hydnaresh-test"
  
}

resource "aws_s3_bucket" "demo" {
    # bucket = "web-dev-bucket"
    # bucket = "${var.layer}-${var.env}-bucket-hyd-${var.region}"
    #bucket-name = "development-dev-bucket-hydnaresh-test"
    bucket = local.bucket-name
    tags = {
        # Name = "${var.layer}-${var.env}-bucket-hyd"
        Name = local.bucket-name
        Environment = var.env
    }
    
 
  
}