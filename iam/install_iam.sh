#! /bin/sh

helm repo add fusionauth https://fusionauth.github.io/charts

# TODO: on dev cluster, make app.runtimeMode = development

# TODO: the admin nodes have python installed, version 2.7.5