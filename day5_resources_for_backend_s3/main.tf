resource "aws_s3_bucket" "example" {
  bucket = "statefile-store"
}

# resource "aws_s3_bucket_acl" "example" {
#   bucket = aws_s3_bucket.example.id
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}
#DynamoDB creation for locking process
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}

