#!/bin/bash


# Post install script for Jerakia

IS_SYSTEMD=$((pidof systemd 2>&1 > /dev/null)  && echo "yes" || echo "no")

if [ "$IS_SYSTEMD" == "yes" ]; then
  cp /opt/jerakia/ext/systemd/jerakia.service /etc/systemd/system/jerakia.service
  systemctl daemon-reload
fi


mkdir -p /var/log/jerakia
mkdir -p /var/db/jerakia
mkdir -p /etc/jerakia/policy.d

[ -f "/etc/jerakia/policy.d/default.rb" ] || cp /opt/jerakia/ext/jerakia/policy.skel.rb /etc/jerakia/policy.d/default.rb
[ -f "/etc/jerakia/jerakia.yaml" ] || cp /opt/jerakia/ext/jerakia/jerakia.skel.yaml /etc/jerakia/jerakia.yaml

chmod 550 /etc/jerakia /etc/jerakia/policy.d
chmod 660 /etc/jerakia/jerakia.yaml /etc/jerakia/policy.d/default.rb
