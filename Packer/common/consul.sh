#!/bin/bash -xe
yum install -y unzip

wget https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip -O consul.zip
unzip consul.zip
mv consul /usr/bin/consul

cat << END > /etc/systemd/system/consul.service
[Unit]
Description=Consul

[Service]
ExecStart=/usr/bin/consul agent -config-file /etc/consul.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
END
