#!/bin/bash
source "/vagrant/scripts/common.sh"

function disableFirewall {
	echo "disabling firewall"

	#service iptables save
	#service iptables stop
	#chkconfig iptables off

	systemctl disable firewalld
}

echo "setup centos"

disableFirewall