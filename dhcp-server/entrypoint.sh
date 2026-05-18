#!/bin/bash
set -e
export INTERFACES=${INTERFACES:-"*"}
if [ -z "$(ls -A /etc/kea)" ]; then
    echo "Config directory /etc/kea is empty. Defaulting to basic configs"
    echo "Generating kea-dhcp4.conf from template using INTERFACES=$INTERFACES"
    envsubst < /etc/kea-distribution/kea-dhcp4.conf.template > /etc/kea/kea-dhcp4.conf
fi

export PGUSER=${DB_USER}
export PGPASSWORD="${DB_PASSWORD}"
export PGHOST="/var/run/postgresql"
until pg_isready -U "$DB_USER" -h "/var/run/postgresql"; do
  sleep 1
done

DB_EXISTS=$(psql -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='kea'")
if [ "$DB_EXISTS" != "1" ]; then
    echo "'kea' database not found. creating..."
    psql -d postgres -c "CREATE DATABASE kea;"
fi

DB_ARGS="-u $DB_USER -p ${DB_PASSWORD} -n kea -a /var/run/postgresql"
if ! kea-admin db-check postgresql $DB_ARGS > /dev/null 2>&1; then
    echo "Tables missing, running migrations..."
    kea-admin db-init postgresql $DB_ARGS
fi

chown -R _kea:_kea /etc/kea /run/kea /var/lib/kea
chmod -R 750 /run/kea

exec "$@"
