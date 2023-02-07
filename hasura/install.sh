#! /bin/sh

cd "${0%/*}"

IAM_RELEASE_NAME=fusionauth
IAM_NAMESPACE=iam
POSTGRESQL_USERNAME=hasura_user
POSTGRESQL_PASSWORD=GfNU3ZLHeHu2Ic3Ioo3hOoLd8Mmm7oJeGmCxKZkmv1RBUA8qJcGmYdzTewjmIuj8
POSTGRESQL_DATABASE_NAME=hasura
HASURA_ADMIN_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
JWT_KEY_ALGORITHM=RS256
HASURA_CLAIMS_NAMESPACE=https://hasura.io/jwt/claims
JWT_ISSUER=jelasticozor.com

POSTGRESQL_HOSTNAME=node155513-jelasticozor-db.hidora.com
POSTGRESQL_PORT=5432
IAM_HOSTNAME=${IAM_RELEASE_NAME}.${IAM_NAMESPACE}
IAM_PORT=9011

#helm repo add nexus https://%system.package-manager.deployer.username%:%system.package-manager.deployer.password%@%system.package-manager.hostname%
#helm repo update

# TODO: we probably want to download another set of values in the production case
HASURA_VALUES=values.yaml

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

helm upgrade --install --create-namespace --namespace ${NAMESPACE} ${RELEASE_NAME} nexus/hasura \
  -f values.yaml
