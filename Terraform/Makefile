args = -var-file ../config.json -var-file ../users.tfvars
TERRAFORM ?= terraform

default: plan

fmt:
	$(TERRAFORM) fmt

plan: fmt
	$(TERRAFORM) plan $(args) -out terraform.plan

build:
	$(TERRAFORM) apply terraform.plan

clean:
	$(TERRAFORM) destroy $(args)

traefik:
	$(TERRAFORM) taint digitalocean_droplet.traefik
