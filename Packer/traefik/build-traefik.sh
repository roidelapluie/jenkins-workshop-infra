#!/bin/bash -xe

yum update -y

wget https://github.com/containous/traefik/releases/download/${traefik_version?required}/traefik_linux-amd64

mv traefik_linux-amd64 /usr/bin/traefik

chmod +x /usr/bin/traefik
setcap cap_net_bind_service=+ep /usr/bin/traefik

useradd -d /var/lib/traefik -s /sbin/nologin traefik

cat << END > /etc/systemd/system/traefik.service
[Unit]
Description=Traefic

[Service]
ExecStart=/usr/bin/traefik -c /etc/traefik.toml
Restart=on-failure
User=traefik
PrivateDevices=yes
PrivateTmp=yes
ProtectHome=yes
ProtectSystem=full

[Install]
WantedBy=multi-user.target
END
