output "bucket_id" {
  value = var.create_bucket ? aws_s3_bucket.bucket[0].id : data.aws_s3_bucket.mybucket[0].id
}

output "object_key" {
  value = aws_s3_bucket_object.object.key
}
