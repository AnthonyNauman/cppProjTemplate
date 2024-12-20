#!/usr/bin/env bash

# === Project variables ===

PROJ_NAME="app"
PROJ_VERSION_MAJOR=4
PROJ_VERSION_MINOR=2
PROJ_VERSION_BUILD=0
PROJ_VERSION_PATCH=7
PROJ_VERSION="$PROJ_VERSION_MAJOR.$PROJ_VERSION_MINOR.$PROJ_VERSION_BUILD.$PROJ_VERSION_PATCH"

# === Project variables ===


# ================================
SCRIPTS_DIR=$( dirname -- "$( readlink -f -- "$0"; )"; )
PROJ_DIR="$(dirname "$SCRIPTS_DIR")"
SOURCE_DIR=$PROJ_DIR/apps
BUILD_DIR=$PROJ_DIR/build
DEV_OPS_DIR=$PROJ_DIR/devops

# echo "=============="
# echo "PROJ DIR: $PROJ_DIR"
# echo "SOURCE DIR: $SOURCE_DIR"
# echo "PROJ Name: $PROJ_NAME"
# echo "PROJ Ver: $PROJ_VERSION"