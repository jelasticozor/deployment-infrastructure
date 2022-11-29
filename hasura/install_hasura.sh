#! /bin/sh

if [ "$#" -ne "12" ] ; then
  echo "Usage: $0 <baseUrl> <postgresReleaseName> <postgresNamespace> <iamReleaseName> <iamNamespace> <postgresqlUsername> <postgresqlPassword> <postgresqlDatabaseName> <hasuraAdminSecret> <jwtKeyAlgorithm> <hasuraClaimsNamespace> <jwtIssuer>"
  exit 1
fi

BASE_URL=$1
POSTGRESQL_RELEASE_NAME=$2
POSTGRESQL_NAMESPACE=$3
IAM_RELEASE_NAME=$4
IAM_NAMESPACE=$5
POSTGRESQL_USERNAME=$6
POSTGRESQL_PASSWORD=$7
POSTGRESQL_DATABASE_NAME=$8
HASURA_ADMIN_SECRET=$9
JWT_KEY_ALGORITHM=${10}
HASURA_CLAIMS_NAMESPACE=${11}
JWT_ISSUER=${12}

POSTGRESQL_HOSTNAME=${POSTGRESQL_RELEASE_NAME}-primary.${POSTGRESQL_NAMESPACE}
POSTGRESQL_PORT=$(kubectl -n ${POSTGRESQL_NAMESPACE} get svc ${POSTGRESQL_RELEASE_NAME} -o jsonpath='{.spec.ports[?(@.protocol=="TCP")].port}')
IAM_HOSTNAME=${IAM_RELEASE_NAME}.${IAM_NAMESPACE}
IAM_PORT=$(kubectl -n ${IAM_NAMESPACE} get svc ${IAM_RELEASE_NAME} -o jsonpath='{.spec.ports[?(@.protocol=="TCP")].port}')

helm repo add platyplus https://charts.platy.plus
helm repo update

# TODO: we probably want to download another set of values in the production case

HASURA_VALUES=/tmp/hasura-values.yaml

wget "${BASE_URL}/hasura/hasura-values.yaml" -O ${HASURA_VALUES}

sed -i s@POSTGRESQL_HOSTNAME@${POSTGRESQL_HOSTNAME}@g ${HASURA_VALUES}
sed -i s/POSTGRESQL_PORT/${POSTGRESQL_PORT}/g ${HASURA_VALUES}
sed -i s/POSTGRESQL_USERNAME/${POSTGRESQL_USERNAME}/g ${HASURA_VALUES}
sed -i s/POSTGRESQL_PASSWORD/${POSTGRESQL_PASSWORD}/g ${HASURA_VALUES}
sed -i s/POSTGRESQL_DATABASE_NAME/${POSTGRESQL_DATABASE_NAME}/g ${HASURA_VALUES}
sed -i s/HASURA_ADMIN_SECRET/${HASURA_ADMIN_SECRET}/g ${HASURA_VALUES}
sed -i s/JWT_KEY_ALGORITHM/${JWT_KEY_ALGORITHM}/g ${HASURA_VALUES}
sed -i s@IAM_HOSTNAME@${IAM_HOSTNAME}@g ${HASURA_VALUES}
sed -i s/IAM_PORT/${IAM_PORT}/g ${HASURA_VALUES}
sed -i s@HASURA_CLAIMS_NAMESPACE@${HASURA_CLAIMS_NAMESPACE}@g ${HASURA_VALUES}
sed -i s/JWT_ISSUER/${JWT_ISSUER}/g ${HASURA_VALUES}

NAMESPACE="api"
RELEASE_NAME="hasura"

helm upgrade --install --create-namespace --namespace ${NAMESPACE} ${RELEASE_NAME} platyplus/hasura \
  -f ${HASURA_VALUES}
