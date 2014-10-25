#!/usr/bin/env bash

sed -i '/puppet-master/ d' /etc/hosts
[[ `grep "192.168.33.10" /etc/hosts | wc -l` -eq 0 ]] && echo -e "192.168.33.10\tpuppet-master.local.vms.com puppet-master puppet" >> /etc/hosts

rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

yum -y install http://yum.theforeman.org/releases/1.6/el6/x86_64/foreman-release.rpm
yum -y install foreman-installer

foreman-installer --foreman-db-type mysql

sed -i 's/show_diff     = false/show_diff     = true/' /etc/puppet/puppet.conf

puppet agent --test

puppet module install -i /etc/puppet/environments/production/modules puppetlabs/ntp

# Configure -> Puppet classes
# import classes
# configure ntp servers
# ntp -> Smart Class Parameter -> servers -> override to array
# ["0.south-america.pool.ntp.org", "1.south-america.pool.ntp.org", "2.south-america.pool.ntp.org", "3.south-america.pool.ntp.org"]
