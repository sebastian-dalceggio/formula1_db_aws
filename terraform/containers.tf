resource "aws_ecr_repository" "create_tables" {
  name = "create_tables"
}

resource "docker_registry_image" "create_tables" {
  name = "${aws_ecr_repository.create_tables.repository_url}:${var.create_tables_tag}"
  build {
    dockerfile = "/create_tables/Dockerfile"
    context = "../scripts"
  }
}

resource "aws_ecr_repository" "load_data" {
  name = "load_data"
}

resource "docker_registry_image" "load_data" {
  name = "${aws_ecr_repository.load_data.repository_url}:${var.load_data_tag}"
  build {
    dockerfile = "/load_data/Dockerfile"
    context = "../scripts"
  }
}

resource "aws_ecr_repository" "api_db" {
  name = "api_db"
}

resource "docker_registry_image" "api_db" {
  name = "${aws_ecr_repository.api_db.repository_url}:${var.api_tag}"
  build {
    dockerfile = "/api/Dockerfile"
    context = "../scripts"
  }
}