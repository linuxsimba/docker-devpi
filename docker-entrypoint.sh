#!/bin/bash

function defaults {
    : ${DEVPI_SERVERDIR="/data/server"}
    : ${DEVPI_CLIENTDIR="/data/client"}
    : ${DEVPI_INDEX="public"}

    echo "DEVPI_SERVERDIR is ${DEVPI_SERVERDIR}"
    echo "DEVPI_CLIENTDIR is ${DEVPI_CLIENTDIR}"

    export DEVPI_SERVERDIR DEVPI_CLIENTDIR
}

function initialise_devpi {
    echo "[RUN]: Initialise devpi-server"
    devpi-server --restrict-modify root --start --host 127.0.0.1 --port 3141
    devpi-server --status
    devpi use http://localhost:3141
    devpi login root --password=''
    devpi user -m root password="${DEVPI_PASSWORD}"
    devpi index -y -c ${DEVPI_INDEX} bases=root/pypi pypi_whitelist='*'
    devpi-server --stop
    devpi-server --status
}

defaults

if [ ! -f  $DEVPI_SERVERDIR/.serverversion ]; then
    initialise_devpi
fi

echo "[RUN]: Launching devpi-server"
exec devpi-server --restrict-modify root --host 0.0.0.0 --port 3141
