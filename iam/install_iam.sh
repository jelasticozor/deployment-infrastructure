#! /bin/sh

if [ "$#" -ne "1" ] ; then
  echo "Usage: $0 <baseUrl>"
  exit 1
fi

BASE_URL=$1

helm repo add fusionauth https://fusionauth.github.io/charts
helm repo update

# TODO: on dev cluster, make app.runtimeMode = development

# TODO: the admin nodes have python installed, version 2.7.5