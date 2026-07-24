target "docker-metadata-action" {}

variable "APP" {
  default = "esphome"
}

variable "VERSION" {
  # renovate: datasource=pypi depName=esphome
  default = "2026.7.2"
}

variable "SOURCE" {
  default = "https://github.com/esphome/esphome"
}

group "default" {
  targets = ["image-local"]
}

target "image-base" {
  inherits = ["docker-metadata-action"]
  args = {
    APP     = "${APP}"
    VERSION = "${VERSION}"
  }
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
}

target "image" {
  inherits  = ["image-base"]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "image-local" {
  inherits = ["image-base"]
  output   = ["type=docker"]
  tags     = ["${APP}:local"]
}
