version = 1.0.1
traefik_version = v1.2.3

build:
	packer build -var-file ../../config.json -var version=$(version) -var traefik_version=$(traefik_version) traefik.json
