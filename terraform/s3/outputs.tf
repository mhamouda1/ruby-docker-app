output "s3_bucket_regional_domain_name" {
  value = "${aws_s3_bucket.main.bucket_regional_domain_name}"
}

output "s3_bucket_name" {
  value = "${aws_s3_bucket.main.bucket}"
}
