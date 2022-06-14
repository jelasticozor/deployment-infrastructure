#! /bin/sh

if [ "$#" -ne "18" ] ; then
  echo "Usage: $0 <baseUrl> <topo> <db-user> <db-user-password> <db-name> <admin-user-email> <admin-user-password> <almighty-api-key> <serverless-api-key> <auth-issuer> <mail-server-host> <mail-server-port> <mail-server-username> <mail-server-password> <mail-server-ssl> <from-email> <from-name> <hasura-claims-namespace>"
  exit 1
fi

BASE_URL=$1
TOPO=$2
DB_USER=$3
DB_USER_PASSWORD=$4
DB_NAME=$5
ADMIN_USER_EMAIL=$6
AUTH_ADMIN_PASSWORD=$7
AUTH_ALMIGHTY_API_KEY=$8
AUTH_SERVERLESS_API_KEY=$9
AUTH_ISSUER=${10}
MAIL_SERVER_HOST=${11}
MAIL_SERVER_PORT=${12}
MAIL_SERVER_USERNAME=${13}
MAIL_SERVER_PASSWORD=${14}
MAIL_SERVER_SSL=${15}
FROM_EMAIL=${16}
FROM_NAME=${17}
HASURA_CLAIMS_NAMESPACE=${18}

helm repo add fusionauth https://fusionauth.github.io/charts
helm repo update

FUSIONAUTH_VALUES=/tmp/fusionauth-values.yaml

wget "${BASE_URL}/iam/fusionauth-values.yaml" -O ${FUSIONAUTH_VALUES}

if [ "$TOPO" = "0-dev" ] ; then
  RUNTIME_MODE="development"
else
  RUNTIME_MODE="production"
fi

# TODO: the two kubectl commands must be adapted if we install postgresql-ha (e.g. for production)
DB_ROOT_USER=postgres
DB_ROOT_USER_PASSWORD=$(kubectl -n database get secret postgresql -o jsonpath={.data.postgres-password} | base64 -d)
DB_HOSTNAME=postgresql.database
DB_PORT=$(kubectl -n database get svc postgresql -o jsonpath='{.spec.ports[?(@.protocol=="TCP")].port}')

sed -i s/RUNTIME_MODE/$RUNTIME_MODE/g ${FUSIONAUTH_VALUES}
sed -i s/AUTH_ROOT_USER/$DB_ROOT_USER/g ${FUSIONAUTH_VALUES}
sed -i s/AUTH_ROOT_PASSWORD/$DB_ROOT_USER_PASSWORD/g ${FUSIONAUTH_VALUES}
sed -i s/AUTH_DB_USERNAME/$DB_USER/g ${FUSIONAUTH_VALUES}
sed -i s/AUTH_DB_USERPASSWORD/$DB_USER_PASSWORD/g ${FUSIONAUTH_VALUES}
sed -i s/AUTH_DATABASE_NAME/$DB_NAME/g ${FUSIONAUTH_VALUES}
sed -i s@AUTH_DATABASE_HOSTNAME@$DB_HOSTNAME@g ${FUSIONAUTH_VALUES}
sed -i s/AUTH_DATABASE_PORT/$DB_PORT/g ${FUSIONAUTH_VALUES}

KICKSTART_JSON=/tmp/kickstart.json
INDENTED_KICKSTART_JSON=/tmp/indented-kickstart.json
KICKSTART_PY=/tmp/setup_kickstart.py
wget "${BASE_URL}/iam/kickstart.json" -O $KICKSTART_JSON 
wget "${BASE_URL}/iam/setup_kickstart.py" -O $KICKSTART_PY

python $KICKSTART_PY --admin-email=${ADMIN_USER_EMAIL} \
    --admin-password ${AUTH_ADMIN_PASSWORD} \
    --almighty-api-key ${AUTH_ALMIGHTY_API_KEY} \
    --serverless-api-key ${AUTH_SERVERLESS_API_KEY} \
    --issuer ${AUTH_ISSUER} \
    --mail-server-host ${MAIL_SERVER_HOST} \
    --mail-server-port ${MAIL_SERVER_PORT} \
    --mail-server-username="${MAIL_SERVER_USERNAME}" \
    --mail-server-password="${MAIL_SERVER_PASSWORD}" \
    --mail-server-enable-ssl="${MAIL_SERVER_SSL}" \
    --from-email ${FROM_EMAIL} \
    --from-name ${FROM_NAME} \
    --hasura-claims-namespace ${HASURA_CLAIMS_NAMESPACE} \
    --input-kickstart ${KICKSTART_JSON} \
    --output-kickstart ${KICKSTART_JSON}
  sed 's/^/      /' $KICKSTART_JSON > $INDENTED_KICKSTART_JSON

cat <<EOT >> ${FUSIONAUTH_VALUES}

environment:
- name: FUSIONAUTH_APP_KICKSTART_FILE
  value: /kickstart/kickstart.json
kickstart:
  enabled: true
  data:
    kickstart.json: |
EOT

# TODO: double-check the format of the fusionauth values yaml file
cat $INDENTED_KICKSTART_JSON >> ${FUSIONAUTH_VALUES}

NAMESPACE=iam

helm install fusionauth fusionauth/fusionauth \
  --create-namespace --namespace ${NAMESPACE} \
  -f ${FUSIONAUTH_VALUES}
