#! /bin/sh

cd "${0%/*}"

helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

NAMESPACE=vault
RELEASE_NAME=vault

helm upgrade --install --create-namespace --namespace ${NAMESPACE} ${RELEASE_NAME} hashicorp/vault