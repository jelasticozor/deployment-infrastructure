#! /bin/sh

helm repo add jetstack https://charts.jetstack.io
helm repo update

NAMESPACE=cert-manager
RELEASE_NAME=cert-manager

cd "${0%/*}"

helm upgrade --install ${RELEASE_NAME} jetstack/cert-manager \
    --namespace="${NAMESPACE}" \
    --create-namespace \
    --set installCRDs=true