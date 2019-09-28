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
