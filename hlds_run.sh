#!/usr/bin/env bash

set -axe

CONFIG_FILE="/opt/hlds/startup.cfg"

if [ -r "${CONFIG_FILE}" ]; then
    source "${CONFIG_FILE}"
fi

EXTRA_OPTIONS="${@}"

EXECUTABLE="/opt/hlds/hlds_run"
GAME="${GAME:-cstrike}"
MAXPLAYERS="${MAXPLAYERS:-32}"
START_MAP="${START_MAP:-de_dust2}"

OPTIONS=( "-game" "${GAME}" "+maxplayers" "${MAXPLAYERS}" "+map" "${START_MAP}")

if [ -z "${RESTART_ON_FAIL}" ]; then
    OPTIONS+=('-norestart')
fi

if [ -n "${ADMIN_STEAM}" ]; then
    echo "\"STEAM_${ADMIN_STEAM}\" \"\"  \"abcdefghijklmnopqrstu\" \"ce\"" >> "/opt/hlds/cstrike/addons/amxmodx/configs/users.ini"
fi

env > "${CONFIG_FILE}"

exec "${EXECUTABLE}" "${OPTIONS[@]}" ${EXTRA_OPTIONS}
