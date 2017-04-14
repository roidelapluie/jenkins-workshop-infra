#!/bin/bash -xe

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

(echo update; echo install java-openjdk; echo install jenkins;  echo run) | yum shell -y

systemctl enable jenkins

sed -i 's@^JENKINS_JAVA_OPTIONS=.*@JENKINS_JAVA_OPTIONS="-Djenkins.install.runSetupWizard=false"@g' -i /etc/sysconfig/jenkins

for d in init.groovy.d userContent
do
    rm -rf /var/lib/jenkins/${d}
    mv /tmp/${d} /var/lib/jenkins/${d}
    chown -R jenkins: /var/lib/jenkins/${d}
done

cat << END > /etc/rc.local
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i eth1 -j ACCEPT
iptables -A INPUT -j REJECT
END

chmod +x /etc/rc.local