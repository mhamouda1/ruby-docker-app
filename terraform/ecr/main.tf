resource "aws_ecr_repository" "ruby-docker-app" {
  name = "ruby-docker-app"
  # image_tag_mutability = "IMMUTABLE"
}
