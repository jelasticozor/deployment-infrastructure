#! /bin/sh

set -e

./cert-manager/install.sh
./mailhog/install.sh
./faas/install.sh
./iam/install.sh
./mq/install.sh
./vault/install.sh