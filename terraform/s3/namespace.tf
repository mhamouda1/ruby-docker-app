resource "random_id" "app_name" {
  byte_length = 11
}

resource "aws_s3_bucket" "app_name" {
  bucket = "${var.app_name}_${random_id.app_name.hex}"
  acl    = "public-read"

  versioning {
    enabled = true
  }

  tags = {
    Name = "$My ${var.app_name} Bucket"
  }
}

resource "aws_s3_bucket_object" "config" {
    bucket = "${aws_s3_bucket.app_name.id}"
    acl    = "public-read"
    key    = "config"
    source = "/dev/null"
}

resource "aws_s3_bucket_object" "environments" {
    bucket = "${aws_s3_bucket.app_name.id}"
    acl    = "public-read"
    key    = "config/environments"
    source = "blah.txt"
}
