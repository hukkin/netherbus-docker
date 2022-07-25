#!/usr/bin/env bash

if [ "$KEYSTORE_PASSWD" != "" ]; then
    echo $KEYSTORE_PASSWD \
    | ./build/nimbus_beacon_node deposits import \
        --data-dir=build/data
else
    echo "keystore password not set. skipping validator keystore import"
fi

exec ./build/nimbus_beacon_node "$@"
