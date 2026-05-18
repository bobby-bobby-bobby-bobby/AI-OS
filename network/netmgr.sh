#!/bin/sh
set -eu
case "${1:-status}" in
  status) echo "wifi=stub ethernet=stub captive_portal=unknown" ;;
  dhcp) echo "dhcp attempt on eth0" > /tmp/dhcp.log ;;
  ntp) ./time/sysctl-time sync ;;
  gui-hook) echo "network gui hook stub" ;;
  *) echo "usage: netmgr.sh {status|dhcp|ntp|gui-hook}"; exit 1;;
esac
