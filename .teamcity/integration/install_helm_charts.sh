#! /bin/sh

set -e

./mailhog/install.sh
./faas/install.sh
./iam/install.sh
./mq/install.sh
./vault/install.sh