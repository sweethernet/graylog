#!/bin/bash

[ $(id -u) -gt 0 ] && echo "root permission required!" && exit 1

sudo sysctl -w vm.max_map_count=262144
if [ -f /etc/sysctl.d/greylog.conf ]; then
  if ! [[ $(grep -c max_map_count /etc/sysctl.d/greylog.conf) -gt 0 ]]; then
    echo 'vm.max_map_count=262144' | tee -a /etc/sysctl.d/greylog.conf
  fi
else
  echo 'vm.max_map_count=262144' | tee -a /etc/sysctl.d/greylog.conf
fi

echo "GRAYLOG_PASSWORD_SECRET=$(pwgen -N 1 -s 96)" |tee .env.secret
echo "GRAYLOG_ROOT_PASSWORD_SHA2=$(pwgen -N 1 -s 20|tee root_sha2_pw|tr -d '\n'|shasum -a 256|awk '{print $1}')"|tee -a .env
