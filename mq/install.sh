#! /bin/sh

cd "${0%/*}"

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

NAMESPACE=message-queue
RELEASE_NAME=rabbitmq

RABBITMQ_PASSWORD=$(kubectl get secret --namespace ${NAMESPACE} ${RELEASE_NAME} -o jsonpath="{.data.rabbitmq-password}" | base64 -d)
RABBITMQ_ERLANG_COOKIE=$(kubectl get secret --namespace ${NAMESPACE} ${RELEASE_NAME} -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d)

helm upgrade --install --create-namespace --namespace ${NAMESPACE} ${RELEASE_NAME} bitnami/rabbitmq \
  -f https://raw.githubusercontent.com/bitnami/charts/master/bitnami/rabbitmq/values.yaml -f values.yaml \
  --set replicaCount=1 \
  --set auth.password="${RABBITMQ_PASSWORD}" \
  --set auth.erlangCookie="${RABBITMQ_ERLANG_COOKIE}" \
  --set containerSecurityContext.allowPrivilegeEscalation=false
