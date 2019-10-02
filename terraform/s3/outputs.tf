output "s3_bucket_regional_domain_name" {
  value = "${aws_s3_bucket.main.bucket_regional_domain_name}"
}

output "bucket_name" {
  value = "${aws_s3_bucket.main.bucket}"
}

output "app_bucket" {
  value = "${aws_s3_bucket.app_name.id}"
}
