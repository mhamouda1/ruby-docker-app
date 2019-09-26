#only provision this once
resource "aws_ecr_repository" "ruby-docker-app" {
  name = "ruby-docker-app"
}
