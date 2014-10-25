#!/usr/bin/env bash

sed -i '/puppet-master/ d' /etc/hosts
[[ `grep "192.168.33.10" /etc/hosts | wc -l` -eq 0 ]] && echo -e "192.168.33.10\tpuppet-master.local.vms.com puppet-master puppet" >> /etc/hosts

sed -i '/puppet-agent/ d' /etc/hosts
[[ `grep "192.168.33.11" /etc/hosts | wc -l` -eq 0 ]] && echo -e "192.168.33.11\tpuppet-agent.local.vms.com puppet-agent" >> /etc/hosts

wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update

apt-get install -y puppet

sed -i 's/^templatedir=/#templatedir=/' /etc/puppet/puppet.conf
sed -i 's/^START=no/START=yes/' /etc/default/puppet

puppet resource service puppet ensure=running enable=true
