resource "random_id" "server" {
  byte_length = 11
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
  source = "../app/assets/images/${var.logo}"
  acl    = "public-read"
  content_type = "image/png"

  etag = "${filemd5("../app/assets/images/logo.png")}"
}

resource "aws_s3_bucket_object" "object2" {
  bucket = "${aws_s3_bucket.main.bucket}"
  key    = "images/${var.logo}"
  source = "../app/assets/images/${var.logo}"
  acl    = "public-read"
  content_type = "image/png"

  etag = "${filemd5("../app/assets/images/logo.png")}"
}
