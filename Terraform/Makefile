args = -var-file ../config.json
TERRAFORM ?= terraform

plan:
	$(TERRAFORM) plan $(args)

build:
	$(TERRAFORM) apply $(args)

clean:
	$(TERRAFORM) destroy $(args)

traefik:
	$(TERRAFORM) taint digitalocean_droplet.traefik
