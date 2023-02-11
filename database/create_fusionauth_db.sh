#! /bin/sh

FUSIONAUTH_DB_NAME=auth
FUSIONAUTH_DB_USERNAME=auth_user
# TODO: let the vault generate this password
FUSIONAUTH_DB_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)

export PGPASSWORD=${DATABASE_ADMIN_PASSWORD}
psql -h "${DATABASE_HOSTNAME}" -p "${DATABASE_PORT}" -U "${DATABASE_ADMIN_USER}" -d postgres <<-EOSQL
  CREATE USER ${FUSIONAUTH_DB_USERNAME} PASSWORD '${FUSIONAUTH_DB_PASSWORD}';
  CREATE DATABASE ${FUSIONAUTH_DB_NAME} ENCODING 'UTF-8' TEMPLATE template0;
EOSQL

echo "##teamcity[setParameter name='env.FUSIONAUTH_DB_NAME' value='${FUSIONAUTH_DB_NAME}']"
echo "##teamcity[setParameter name='env.FUSIONAUTH_DB_USERNAME' value='${FUSIONAUTH_DB_USERNAME}']"
# TODO: do not publish this value, store it in the vault instead
echo "##teamcity[setParameter name='env.FUSIONAUTH_DB_PASSWORD' value='${FUSIONAUTH_DB_PASSWORD}']"
