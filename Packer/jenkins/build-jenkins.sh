#!/bin/bash -xe

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

(
# echo update
 echo install java-openjdk
 echo install jenkins
 echo install git
 echo install python3
 echo install python3-devel
 echo install python
 echo install python-devel
 echo run
 ) | yum shell -y

easy_install pip virtualenv

systemctl enable jenkins

sed -i 's@^JENKINS_JAVA_OPTIONS=.*@JENKINS_JAVA_OPTIONS="-Djenkins.install.runSetupWizard=false"@g' -i /etc/sysconfig/jenkins

cat << END > /etc/rc.local
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i eth1 -j ACCEPT
iptables -A INPUT -j REJECT
END

service jenkins start

timeout 90 bash -c "until wget http://127.0.0.1:8080/
do
    sleep 1
done"

wget http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar -O jenkins-cli.jar

java -jar jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin antisamy-markup-formatter
java -jar jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin git

chmod +x /etc/rc.local

for d in init.groovy.d userContent
do
    rm -rf /var/lib/jenkins/${d}
    mv /tmp/${d} /var/lib/jenkins/${d}
    chown -R jenkins: /var/lib/jenkins/${d}
done

