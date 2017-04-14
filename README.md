# Setup Jenkins instances ready for a workshop

## Howto

- Create config.json
- Create Jenkins and Treafik snapshots

```
(cd Packer/jenkins && make)
(cd Packer/traefik && make)
```

- Create SSL certs (e.g. [LE with DNS
  proof](https://hub.docker.com/r/gibby/letsencrypt-dns-digitalocean/)) and copy
  them to certs/

- Build your cloud

```
cd Terraform
make build
```
