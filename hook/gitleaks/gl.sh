#!/usr/bin/env bash
set -e

DEFAULT_BIN_DIR="/usr/local/bin"
BIN_DIR=${1:-"${DEFAULT_BIN_DIR}"}
GITHUB_REPO="zricethezav/gitleaks"

# Set os, fatal if operating system not supported
setup_verify_os() {
    if [[ -z "${OS}" ]]; then
        OS=$(uname)
    fi
    case ${OS} in
        Darwin)
            OS=darwin
            ;;
        Linux)
            OS=linux
            ;;
        *)
            fatal "Unsupported operating system ${OS}"
    esac
}
# Set arch, fatal if architecture not supported
setup_verify_arch() {
    if [[ -z "${ARCH}" ]]; then
        ARCH=$(uname -m)
    fi
    case ${ARCH} in
        arm|armv6l|armv7l)
            ARCH=arm
            ;;
        arm64)
            ARCH=arm64
            ;;
        amd64)
            ARCH=x64
            ;;
        x86_64)
            ARCH=x64
            ;;
        *)
            fatal "Unsupported architecture ${ARCH}"
    esac
}

# Download binary from Github URL
download_binary() {

    TMP_DIR="$(mktemp -d -t tmp-install.XXXXXXXXXX)"
    cd "${TMP_DIR}"
    
    BIN_URL="https://api.github.com/repos/zricethezav/gitleaks/releases/latest"
    
    curl -LO "$(curl -Ls ${BIN_URL} | grep 'browser_download_url' | cut -d '"' -f 4 | grep "${OS}_${ARCH}.tar.gz$")"
    
    INST_BIN="$(ls)"

}

#install binary

install_binary() {

NEW_BIN="$(tar -tzf ${INST_BIN} | awk "NR==3{print $NF}")"
tar -xzof "${INST_BIN}"

local CMD_MOVE="mv -f \"${NEW_BIN}\" \"${BIN_DIR}\""
    if [[ -w "${BIN_DIR}" ]]; then
        eval "${CMD_MOVE}"
    else
        eval "sudo ${CMD_MOVE}"
    fi

which "${NEW_BIN}"

cleanup() {
        local code=$?
        set +e
        trap - EXIT
        rm -rf "${TMP_DIR}"
        exit ${code}
    }
    trap cleanup INT EXIT

}

{    
    setup_verify_os
    setup_verify_arch
    download_binary
    install_binary

}