#! /bin/sh

if [ "$#" -ne "7" ] ; then
  echo "Usage: $0 baseUrl hasura-db-name hasura-db-username hasura-db-password fusionauth-db-name fusionauth-db-username fusionauth-db-password"
  exit 1
fi

BASE_URL=$1
HASURA_DB_NAME=$2
HASURA_DB_USERNAME=$3
HASURA_DB_PASSWORD=$4
FUSIONAUTH_DB_NAME=$5
FUSIONAUTH_DB_USERNAME=$6
FUSIONAUTH_DB_PASSWORD=$7

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

wget "${BASE_URL}/database/postgresql-values.yaml" -O /tmp/postgresql-values.yaml

sed -i s/HASURA_DB_USERNAME/${HASURA_DB_USERNAME}/g /tmp/postgresql-values.yaml
sed -i s/HASURA_DB_PASSWORD/${HASURA_DB_PASSWORD}/g /tmp/postgresql-values.yaml
sed -i s/HASURA_DB_NAME/${HASURA_DB_NAME}/g /tmp/postgresql-values.yaml
sed -i s/FUSIONAUTH_DB_USERNAME/${FUSIONAUTH_DB_USERNAME}/g /tmp/postgresql-values.yaml
sed -i s/FUSIONAUTH_DB_PASSWORD/${FUSIONAUTH_DB_PASSWORD}/g /tmp/postgresql-values.yaml
sed -i s/FUSIONAUTH_DB_NAME/${FUSIONAUTH_DB_NAME}/g /tmp/postgresql-values.yaml

NAMESPACE=database

helm install --create-namespace --namespace ${NAMESPACE} postgresql bitnami/postgresql \
  -f /tmp/postgresql-values.yaml --wait