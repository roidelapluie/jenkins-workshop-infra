traefik_version = v1.2.3
include ../common/Makefile.mk

build:
	packer build -var-file ../../config.json -var traefik_version=$(traefik_version) -var consul_version=$(consul_version) traefik.json
