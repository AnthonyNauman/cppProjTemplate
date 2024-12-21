#!/bin/bash

source $(dirname $0)/project_info.sh

CONAN_BUILD_DIR=$BUILD_DIR/dev_container/conan
DEV_CONT_BUILD_DIR=$BUILD_DIR/dev_container/$BUILD_TYPE
COMPILER_CPPSTD=$CPPSTD_PREFIX$CPP_STANDART