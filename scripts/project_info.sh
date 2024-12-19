#!/usr/bin/env bash

# === Project variables ===

PROJ_NAME="App"
PROJ_VERSION_MAJOR=1
PROJ_VERSION_MINOR=0
PROJ_VERSION_BUILD=0
PROJ_VERSION_PATCH=0
PROJ_VERSION="$PROJ_VERSION_MAJOR.$PROJ_VERSION_MINOR.$PROJ_VERSION_BUILD.$PROJ_VERSION_PATCH"

# === Project variables ===





# ================================
SCRIPTS_DIR=$( dirname -- "$( readlink -f -- "$0"; )"; )
PROJ_DIR="$(dirname "$SCRIPTS_DIR")"
SOURCE_DIR=$PROJ_DIR/apps
DEV_OPS_DIR=$PROJ_DIR/devops

echo "=============="
echo "PROJ DIR: $PROJ_DIR"
echo "SOURCE DIR: $SOURCE_DIR"
echo "PROJ Name: $PROJ_NAME"
echo "PROJ Ver: $PROJ_VERSION"