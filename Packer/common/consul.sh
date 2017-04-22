#!/bin/bash -xe
yum install -y unzip

wget https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip -O consul.zip
unzip consul.zip
rm consul.zip
mv consul /usr/bin/consul
mkdir /etc/consul.d

useradd -s /sbin/nologin -d /var/lib/consul consul
mkdir /var/lib/consul
chown consul: /var/lib/consul

cat << END > /etc/systemd/system/consul.service
[Unit]
Description=Consul

[Service]
ExecStart=/usr/bin/consul agent -config-dir=/etc/consul.d
ExecStartPost=/usr/bin/sleep 5
Restart=on-failure
User=consul

[Install]
WantedBy=multi-user.target
END
