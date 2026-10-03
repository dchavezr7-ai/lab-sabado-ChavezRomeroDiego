# ---------- IMÁGENES ----------
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_image" "node" {
  name         = "node:20-alpine"
  keep_locally = true
}

resource "docker_image" "postgres" {
  name         = "postgres:16"
  keep_locally = true
}

# ---------- REDES ----------
resource "docker_network" "red_dev" {
  name = "red-dev"
}

resource "docker_network" "red_qa" {
  name = "red-qa"
}

# ---------- DEV ----------
resource "docker_container" "web_dev" {
  name  = "web-dev"
  image = docker_image.nginx.image_id
  ports {
    internal = 80
    external = var.web_server_port["dev"]
  }
  networks_advanced {
    name = docker_network.red_dev.name
  }
}

resource "docker_container" "api_dev" {
  name    = "api-dev"
  image   = docker_image.node.image_id
  command = ["tail", "-f", "/dev/null"]
  ports {
    internal = 3000
    external = var.api_port["dev"]
  }
  networks_advanced {
    name = docker_network.red_dev.name
  }
}

resource "docker_container" "bd_dev" {
  name  = "bd-dev"
  image = docker_image.postgres.image_id
  env   = ["POSTGRES_PASSWORD=postgres"]
  ports {
    internal = 5432
    external = var.db_port["dev"]
  }
  networks_advanced {
    name = docker_network.red_dev.name
  }
}

# ---------- QA ----------
resource "docker_container" "web_qa" {
  name  = "web-qa"
  image = docker_image.nginx.image_id
  ports {
    internal = 80
    external = var.web_server_port["qa"]
  }
  networks_advanced {
    name = docker_network.red_qa.name
  }
}

resource "docker_container" "api_qa" {
  name    = "api-qa"
  image   = docker_image.node.image_id
  command = ["tail", "-f", "/dev/null"]
  ports {
    internal = 3000
    external = var.api_port["qa"]
  }
  networks_advanced {
    name = docker_network.red_qa.name
  }
}

resource "docker_container" "bd_qa" {
  name  = "bd-qa"
  image = docker_image.postgres.image_id
  env   = ["POSTGRES_PASSWORD=postgres"]
  ports {
    internal = 5432
    external = var.db_port["qa"]
  }
  networks_advanced {
    name = docker_network.red_qa.name
  }
}