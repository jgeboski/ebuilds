#!/bin/bash

if [ -e /etc/make.conf ]; then
    source /etc/make.conf
fi

if [ -e /etc/portage/make.conf ]; then
    source /etc/portage/make.conf
fi

PORTAGE_TMPDIR=${PORTAGE_TMPDIR:-/var/tmp}
TMPDIR="${PORTAGE_TMPDIR}/portage"

jge_log_error() {
    echo -e "error: ${@}" >&2
    return 1
}

jge_log_notice() {
    echo -e "!!! ${@} !!!"
}

jge_require_user() {
    if [ "${1}" != "${USER}" ]; then
        jge_log_error "must run as ${1}"
        return 1
    fi
}

jge_require_vars() {
    for var in ${@}; do
        if [ -z "${!var}" ]; then
            jge_log_error "${var} is not defined"
            return 1
        fi
    done
}
