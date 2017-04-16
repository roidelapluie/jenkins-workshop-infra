include ../common/Makefile.mk

build:
	packer build -var-file ../../config.json -var consul_version=$(consul_version) jenkins.json
