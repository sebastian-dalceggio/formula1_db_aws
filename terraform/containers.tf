resource "aws_ecr_repository" "load_data" {
  name = "load_data"
}

resource "docker_registry_image" "load_data" {
  name = "${aws_ecr_repository.load_data.repository_url}:${var.load_data_tag}"
  build {
    context = "../load_data"
  }
}

resource "aws_ecr_repository" "api-db" {
  name = "api_db"
}

resource "docker_registry_image" "api-db" {
  name = "${aws_ecr_repository.api-db.repository_url}:${var.api_tag}"
  build {
    context = "../api"
  }
}