target "docker-metadata-action" {}

variable "APP" {
  default = "esphome"
}

variable "BASE_IMAGE" {
  # renovate: datasource=docker depName=ghcr.io/linuxserver/baseimage-alpine versioning=docker
  default = "ghcr.io/linuxserver/baseimage-alpine:3.23@sha256:256a895076e4fc30903c02b7af461bd78761dc61ac69bb01ae97b3eb774789e0"
}

variable "VERSION" {
  # renovate: datasource=pypi depName=esphome
  default = "2026.5.1"
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
    APP        = "${APP}"
    BASE_IMAGE = "${BASE_IMAGE}"
    VERSION    = "${VERSION}"
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
