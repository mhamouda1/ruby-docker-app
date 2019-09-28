resource "random_id" "server" {
  byte_length = 8
}

resource "aws_s3_bucket" "main" {
  bucket = "my-s3-bucket-${random_id.server.b64}"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "${terraform.workspace} - My bucket"
  }
}
