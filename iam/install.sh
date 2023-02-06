#! /bin/sh

cd "${0%/*}"

RELEASE_NAME=fusionauth
NAMESPACE=iam

ADMIN_USER_EMAIL=softozor@gmail.com

ADMIN_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
ALMIGHTY_API_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
SERVERLESS_API_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)

cat <<EOF | kubectl create -n ${NAMESPACE} -f -
apiVersion: v1
kind: Secret
metadata:
  name: fusionauth
type: Opaque
data:
  admin-password: $(echo "${ADMIN_PASSWORD}" | base64)
  almighty-api-key: $(echo "${ALMIGHTY_API_KEY}" | base64)
  serverless-api-key: $(echo "${SERVERLESS_API_KEY}" | base64)
EOF

AUTH_ISSUER=jelasticozor.com

MAIL_SERVER_HOST=mailhog.mail
MAIL_SERVER_PORT=1025
MAIL_SERVER_USERNAME=""
MAIL_SERVER_PASSWORD=""
MAIL_SERVER_SSL="false"

FROM_EMAIL=info@no-reply.com
FROM_NAME=info

HASURA_CLAIMS_NAMESPACE=https://hasura.io/jwt/claims

helm repo add fusionauth https://fusionauth.github.io/charts
helm repo update

FUSIONAUTH_VALUES=values.yaml

KICKSTART_JSON=kickstart.json
INDENTED_KICKSTART_JSON=indented-kickstart.json
KICKSTART_PY=setup_kickstart.py

python $KICKSTART_PY --admin-email=${ADMIN_USER_EMAIL} \
    --admin-password "${ADMIN_PASSWORD}" \
    --almighty-api-key "${ALMIGHTY_API_KEY}" \
    --serverless-api-key "${SERVERLESS_API_KEY}" \
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

cat $INDENTED_KICKSTART_JSON >> ${FUSIONAUTH_VALUES}

helm upgrade --install ${RELEASE_NAME} fusionauth/fusionauth \
  --create-namespace --namespace ${NAMESPACE} \
  -f ${FUSIONAUTH_VALUES} \
  --set database.root.user="${DATABASE_ADMIN_USER}" \
  --set database.root.password="${DATABASE_ADMIN_PASSWORD}" \
  --set database.host="${DATABASE_HOSTNAME}" \
  --set database.port="${DATABASE_PORT}" \
  --set database.name="${FUSIONAUTH_DB_NAME}" \
  --set database.user="${FUSIONAUTH_DB_USERNAME}" \
  --set database.password="${FUSIONAUTH_DB_PASSWORD}"
