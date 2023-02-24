#! /bin/sh

set -e

# cert manager has already been installed through the k8s manifest
./mailhog/install.sh
./faas/install.sh
./iam/install.sh
./mq/install.sh
./vault/install.sh