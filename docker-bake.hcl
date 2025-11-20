variable "REGISTRY" {
  default = "docker.io"
}

variable "IMAGE_NAME" {
  default = "alpine/ollama"
}

variable "TAG" {
  default = "latest"
}

variable "LABELS" {
  default = {}
}

group "default" {
  targets = ["ollama-multiarch"]
}

target "docker-metadata-action" {}

target "ollama-multiarch" {
  inherits = ["docker-metadata-action"]
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  cache-from = ["type=gha"]
  cache-to = ["type=gha,mode=max"]
}
