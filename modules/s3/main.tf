resource "aws_s3_bucket" "two_tier" {
    bucket = var.aws_s3
    region = var.aws_s3_region
}

resource "aws_s3_bucket_versioning" "two_tier" {
    bucket = aws_s3_bucket.two_tier.id

    versioning_configuration {
      status = "Enabled"
    }
  
}

resource "aws_s3_account_public_access_block" "two_tier" {

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true 

}

resource "aws_dynamodb_table" "two_tier" {
    name = "two-tier"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
}