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

#resource "null_resource" "null_id" {
#  provisioner "local-exec" {
#  command = <<EOT
#    aws s3 cp s3/logo.png s3://${aws_s3_bucket.main.bucket}
#EOT
#  }
#}

resource "aws_s3_bucket_object" "object" {
  bucket = "${aws_s3_bucket.main.bucket}"
  key    = "${var.logo}"
  source = "./s3/${var.logo}"
  acl    = "public-read"
  content_type = "image/png"

  etag = "${filemd5("./s3/logo.png")}"
}
