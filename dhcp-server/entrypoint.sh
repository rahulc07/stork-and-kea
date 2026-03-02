#!/bin/bash
set -e
export INTERFACES=${INTERFACES:-"*"}
if [ -z "$(ls -A /etc/kea)" ]; then
    echo "Config directory /etc/kea is empty. Defaulting to basic configs"
    echo "Generating kea-dhcp4.conf from template using INTERFACES=$INTERFACES"
    envsubst < /etc/kea-distribution/kea-dhcp4.conf.template > /etc/kea/kea-dhcp4.conf
fi
chown -R _kea:_kea /etc/kea /run/kea
chmod -R 750 /run/kea

exec "$@"
