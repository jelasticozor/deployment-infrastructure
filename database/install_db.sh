#! /bin/sh

if [ "$#" -ne "11" ] ; then
  echo "Usage: $0 baseUrl release-name namespace hasura-db-name hasura-db-username hasura-db-password fusionauth-db-name fusionauth-db-username fusionauth-db-password postgres-password replication-password"
  exit 1
fi

BASE_URL=$1
RELEASE_NAME=$2
NAMESPACE=$3
HASURA_DB_NAME=$4
HASURA_DB_USERNAME=$5
HASURA_DB_PASSWORD=$6
FUSIONAUTH_DB_NAME=$7
FUSIONAUTH_DB_USERNAME=$8
FUSIONAUTH_DB_PASSWORD=$9
POSTGRES_PASSWORD=${10}
POSTGRES_REPLICATION_PASSWORD=${11}

SECRET_NAME=postgresql

kubectl create namespace ${NAMESPACE}

cat <<EOF | kubectl create -n ${NAMESPACE} -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${SECRET_NAME}
type: Opaque
data:
  postgres-password: $(echo "${POSTGRES_PASSWORD}" | base64)
  replication-password: $(echo "${POSTGRES_REPLICATION_PASSWORD}" | base64)
EOF

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

POSTGRES_VALUES=/tmp/postgresql-values.yaml
wget "${BASE_URL}/database/postgresql-values.yaml" -O ${POSTGRES_VALUES}

sed -i s/SECRET_NAME/${SECRET_NAME}/g ${POSTGRES_VALUES}
sed -i s/HASURA_DB_USERNAME/${HASURA_DB_USERNAME}/g ${POSTGRES_VALUES}
sed -i s/HASURA_DB_PASSWORD/${HASURA_DB_PASSWORD}/g ${POSTGRES_VALUES}
sed -i s/HASURA_DB_NAME/${HASURA_DB_NAME}/g ${POSTGRES_VALUES}
sed -i s/FUSIONAUTH_DB_USERNAME/${FUSIONAUTH_DB_USERNAME}/g ${POSTGRES_VALUES}
sed -i s/FUSIONAUTH_DB_PASSWORD/${FUSIONAUTH_DB_PASSWORD}/g ${POSTGRES_VALUES}
sed -i s/FUSIONAUTH_DB_NAME/${FUSIONAUTH_DB_NAME}/g ${POSTGRES_VALUES}

helm upgrade --install --create-namespace --namespace ${NAMESPACE} ${RELEASE_NAME} bitnami/postgresql \
  -f ${POSTGRES_VALUES} --wait