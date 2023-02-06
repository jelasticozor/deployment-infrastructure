#! /bin/sh

HASURA_DB_NAME=hasura
HASURA_DB_USERNAME=hasura_user
HASURA_DB_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)

export PGPASSWORD=${DATABASE_ADMIN_PASSWORD}
psql -h "${DATABASE_HOSTNAME}" -p "${DATABASE_PORT}" -U "${DATABASE_ADMIN_USER}" <<-EOSQL
  CREATE USER ${HASURA_DB_USERNAME} PASSWORD '${HASURA_DB_PASSWORD}';
  CREATE DATABASE ${HASURA_DB_NAME} OWNER ${HASURA_DB_USERNAME} ENCODING 'utf-8' TEMPLATE template0;
EOSQL

echo "##teamcity[setParameter name='env.HASURA_DB_NAME' value='${HASURA_DB_NAME}']"
echo "##teamcity[setParameter name='env.HASURA_DB_USERNAME' value='${HASURA_DB_USERNAME}']"
echo "##teamcity[setParameter name='env.HASURA_DB_PASSWORD' value='${HASURA_DB_PASSWORD}']"
