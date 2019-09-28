resource "random_id" "server" {
  byte_length = 8
}

resource "aws_s3_bucket" "main" {
  bucket = "mys3-bucket-${random_id.server.hex}"
  acl    = "public-read"

  versioning {
    enabled = true
  }

  tags = {
    Name = "${terraform.workspace} - My bucket"
  }
}

resource "aws_s3_bucket_object" "object1" {
  bucket = "${aws_s3_bucket.main.bucket}"
  key    = "assets/${var.logo}"
  source = "~/code/ruby-docker-app/app/assets/images/${var.logo}"
  acl    = "public-read"
  content_type = "image/png"

  etag = "${filemd5("~/code/ruby-docker-app/app/assets/images/logo.png")}"
}

resource "aws_s3_bucket_object" "object2" {
  bucket = "${aws_s3_bucket.main.bucket}"
  key    = "images/${var.logo}"
  source = "~/code/ruby-docker-app/app/assets/images/${var.logo}"
  acl    = "public-read"
  content_type = "image/png"

  etag = "${filemd5("~/code/ruby-docker-app/app/assets/images/logo.png")}"
}
