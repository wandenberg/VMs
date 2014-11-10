#!/usr/bin/env bash

rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

yum -y install puppet

sed -i 's/^templatedir/#templatedir/' /etc/puppet/puppet.conf

puppet resource service puppet ensure=running enable=true

puppet agent --test

exit 0