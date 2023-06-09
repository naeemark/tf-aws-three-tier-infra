###########################################################
# Terraform Backend Resources
###########################################################

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket        = "tf-task-tfstate-bucket"
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket = aws_s3_bucket.terraform_state_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks_table" {
  name         = "tf-task-state-locking-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  tags         = var.tags
  attribute {
    name = "LockID"
    type = "S"
  }
}
