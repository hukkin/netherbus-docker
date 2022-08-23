#!/usr/bin/env bash

if [ "$KEYSTORE_PASSWD" != "" ]; then
    echo $KEYSTORE_PASSWD \
    | ./build/nimbus_beacon_node deposits import \
        --data-dir=build/data
else
    echo "keystore password not set. skipping validator keystore import"
fi

if [ "$ENABLE_MEVBOOST" != "" ]; then
	mevboost_flags="--payload-builder --payload-builder-url=http://mevboost:18550"
fi

exec ./build/nimbus_beacon_node "$@" \
    $mevboost_flags
