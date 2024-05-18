terraform {
  backend "s3" {
    bucket = "statefile-store"
    key    = "terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-state-lock-dynamo" # DynamoDB table used for state locking, note: first run day-4-statefile-create=s3
    encrypt        = true  # Ensures the state is encrypted at rest in S3.
}
}
