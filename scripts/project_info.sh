#!/usr/bin/env bash

# === Project variables ===

PROJ_NAME="app"
PROJ_VERSION_MAJOR=4
PROJ_VERSION_MINOR=2
PROJ_VERSION_BUILD=0
PROJ_VERSION_PATCH=7
PROJ_VERSION="$PROJ_VERSION_MAJOR.$PROJ_VERSION_MINOR.$PROJ_VERSION_BUILD.$PROJ_VERSION_PATCH"


# === Build variables ===

export CPP_STANDART=17
export ARCH=x86_64
export BUILD_TYPE=Release
export COMPILER=gcc
export COMPILER_VERSION=10
export CPPSTD_PREFIX=gnu


# === Dirs ===

SCRIPTS_DIR=$( dirname -- "$( readlink -f -- "$0"; )"; )
PROJ_DIR="$(dirname "$SCRIPTS_DIR")"
APPS_DIR=$PROJ_DIR/apps
TESTS_DIR=$PROJ_DIR/tests
SOURCE_DIR=$PROJ_DIR #$APPS_DIR/$PROJ_NAME
BUILD_DIR=$PROJ_DIR/build
INSTALL_DIR=$PROJ_DIR/install
TOOLS_DIR=$PROJ_DIR/tools
UTILS_DIR=$PROJ_DIR/utils

# === Files ===

CONAN_PROFILE=$PROJ_DIR/conanProfile

# echo "=============="
# echo "PROJ DIR: $PROJ_DIR"
# echo "SOURCE DIR: $SOURCE_DIR"
# echo "PROJ Name: $PROJ_NAME"
# echo "PROJ Ver: $PROJ_VERSION"