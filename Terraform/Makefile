args = -var-file ../config.json

plan:
	terraform plan $(args)

build:
	terraform apply $(args)

clean:
	terraform destroy $(args)

traefik:
	terraform taint digitalocean_droplet.traefik
