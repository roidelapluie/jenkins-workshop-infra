#!/bin/bash -xe

wget https://github.com/containous/traefik/releases/download/${traefik_version?required}/traefik_linux-amd64

mv traefik_linux-amd64 /usr/bin/traefik

chmod +x /usr/bin/traefik

cat << END > /etc/systemd/system/traefik.service
[Unit]
Description=Traefic

[Service]
ExecStart=/usr/bin/traefik -c /etc/traefik.toml
Restart=on-failure

[Install]
WantedBy=multi-user.target
END
