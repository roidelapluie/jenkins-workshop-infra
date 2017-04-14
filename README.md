# Setup Jenkins instances ready for a workshop

## Howto

- Create config.json
- Delegate one of your DNS (sub)domains to DigitalOcean (e.g.
  workshop.example.com)
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

`make build` will also return the random admin passwords:

```
addresses-passwords = {
  jenkins01 = 86f79951
  jenkins02 = ac410128
  jenkins03 = 46e742c7
  jenkins04 = aa6f28ec
}
```

You could then login to https://jenkins01.workshop.example.com with
admin/86f79951.
