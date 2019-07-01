#!/bin/bash

# Explicitly set data and extension locations every time for consistency, but allow for override
[ -z "$CS_DATADIR" ] && export CS_DATADIR="/home/coder/.local/share/code-server"
[ -z "$CS_EXTDIR" ] && export CS_EXTDIR="$CS_DATADIR/extensions"

echo "installing additional extensions..."
install_extensions.sh $ADDL_EXTENSIONS_URL

[ ! -z "$CS_CERT" ] && PARAMS="$PARAMS --cert $CS_CERT"
[ ! -z "$CS_CERTKEY" ] && PARAMS="$PARAMS --cert-key $CS_CERTKEY"
PARAMS="$PARAMS --extensions-dir $CS_EXTDIR"
PARAMS="$PARAMS --user-data-dir $CS_DATADIR"
[ ! -z "$CS_HOST" ] && PARAMS="$PARAMS --host $CS_HOST"
[ ! -z "$CS_PORT" ] && PARAMS="$PARAMS --port $CS_PORT"
[ ! -z "$CS_NOAUTH" ] && PARAMS="$PARAMS --no-auth"
[ ! -z "$CS_ALLOWHTTP" ] && PARAMS="$PARAMS --allow-http"
[ ! -z "$CS_PASSWORD" ] && export PASSWORD=$CS_PASSWORD
[ ! -z "$CS_DISABLETELEMETRY" ] && PARAMS="$PARAMS --disable-telemetry"

echo "starting with params: $PARAMS"
code-server $PARAMS
