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

wget "${BASE_URL}/database/values.yaml" -O postgresql-values.yaml

sed -i s/HASURA_DB_USERNAME/${HASURA_DB_USERNAME}/g postgresql-values.yaml
sed -i s/HASURA_DB_PASSWORD/${HASURA_DB_PASSWORD}/g postgresql-values.yaml
sed -i s/HASURA_DB_NAME/${HASURA_DB_NAME}/g postgresql-values.yaml
sed -i s/FUSIONAUTH_DB_USERNAME/${FUSIONAUTH_DB_USERNAME}/g postgresql-values.yaml
sed -i s/FUSIONAUTH_DB_PASSWORD/${FUSIONAUTH_DB_PASSWORD}/g postgresql-values.yaml
sed -i s/FUSIONAUTH_DB_NAME/${FUSIONAUTH_DB_NAME}/g postgresql-values.yaml

kubectl create namespace database

helm install --namespace database postgresql bitnami/postgresql \
  -f postgresql-values.yaml