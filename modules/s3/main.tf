
# Create the bucket if needed
resource "aws_s3_bucket" "bucket" {
  count  = var.create_bucket ? 1 : 0
  bucket = var.bucket_name
}

# Get the bucket reference
data "aws_s3_bucket" "mybucket" {
  count  = var.create_bucket ? 0 : 1
  bucket = var.bucket_name
}

# Create the object on that bucket
resource "aws_s3_bucket_object" "object" {
  bucket = var.create_bucket ? aws_s3_bucket.bucket[0].id : data.aws_s3_bucket.mybucket[0].id
  key    = var.object_key
  source = var.object_path
}
