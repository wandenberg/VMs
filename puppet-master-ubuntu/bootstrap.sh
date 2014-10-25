#!/usr/bin/env bash

sed -i '/puppet-master/ d' /etc/hosts
[[ `grep "192.168.33.10" /etc/hosts | wc -l` -eq 0 ]] && echo -e "192.168.33.10\tpuppet-master.local.vms.com puppet-master puppet" >> /etc/hosts

wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb

echo "deb http://deb.theforeman.org/ trusty 1.6" > /etc/apt/sources.list.d/foreman.list
echo "deb http://deb.theforeman.org/ plugins 1.6" >> /etc/apt/sources.list.d/foreman.list
wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add -

apt-get update

apt-get install -y puppetmaster-passenger
apt-get install -y foreman-installer

foreman-installer --foreman-db-type mysql --foreman-admin-password admin

sed -i 's/^templatedir/#templatedir/'                  /etc/puppet/puppet.conf
sed -i 's/show_diff     = false/show_diff     = true/' /etc/puppet/puppet.conf

puppet agent --test

puppet module install -i /etc/puppet/environments/production/modules puppetlabs/ntp

# Configure -> Puppet classes
# import classes
# configure ntp servers
# ntp -> Smart Class Parameter -> servers -> override to array
# ["0.south-america.pool.ntp.org", "1.south-america.pool.ntp.org", "2.south-america.pool.ntp.org", "3.south-america.pool.ntp.org"]
