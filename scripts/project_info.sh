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
export BUILD_TESTS=OFF
export BUILD_APPS=ON
export BUILD_TARGS=Apps
export USE_CONAN=false
export USE_DOCKER=false



# === Dirs ===

SCRIPTS_DIR=$( dirname -- "$( readlink -f -- "$0"; )"; )
PROJ_DIR="$(dirname "$SCRIPTS_DIR")"
APPS_DIR=$PROJ_DIR/apps
TESTS_DIR=$PROJ_DIR/tests
SOURCE_DIR=$PROJ_DIR 
BUILD_DIR=$PROJ_DIR/build
ARTIFACTS_DIR=$PROJ_DIR/artifacts
INSTALL_DIR=$ARTIFACTS_DIR/bin
TOOLS_DIR=$PROJ_DIR/tools
UTILS_DIR=$ARTIFACTS_DIR/utils
CONAN_BUILD_DIR=$BUILD_DIR/conan
PROJ_BUILD_DIR=$BUILD_DIR/$BUILD_TYPE
USE_VSCODE=true
VSCODE_DIR=$PROJ_DIR/.vscode

# === Files ===
CONAN_PROFILE=$PROJ_DIR/conanProfile
CONAN_TOOLCHAIN=$CONAN_BUILD_DIR/conan_toolchain.cmake
DOCKER_FILE=$PROJ_DIR/Dockerfile



# === Functions ===

collect_directories() {
    local dir="$1"
    local -n dir_array="$2"

    for item in "$dir"/*; do
        if [ -d "$item" ]; then
            dir_array+=("$(basename "$item")")
        fi
    done
}

run_tests_with_report() {
    local dir="$1"
    local executables=()

    while IFS= read -r -d '' file; do
        executables+=("$file")
    done < <(find "$dir" -type f -executable -print0)

    for exe in "${executables[@]}"; do
        test_name=$(basename "$(dirname "$exe")")
		proj=$(basename "$(dirname $(dirname "$exe"))")

		export GCOV_PREFIX="$cov_folder/$proj/$test_name"
		export GCOV_PREFIX_STRIP=16
		chmod +x $exe 
		$exe --gtest_output=xml:$report_folder/xunit.xml
		 
    done
}

conan_install() {

    local arch=$1
    local build_type=$2
    local conan_profile=$3
    local conan_file_dir=$4
    local conan_build_dir=$5

    echo "================ Conan install =================="
    tmp_conan_profile=$(dirname "$conan_profile")/conanTmpProfile
    cp $conan_profile $tmp_conan_profile

    # change conan profile
    sed -i "s|^arch*=.*|arch=$arch|" "$tmp_conan_profile"
    sed -i "s|^build_type*=.*|build_type=$build_type|" "$tmp_conan_profile"

    mkdir -p $conan_build_dir
    conan install $conan_file_dir --output-folder=$conan_build_dir --profile=conanTmpProfile --profile:build=conanTmpProfile --build=missing
    rm $tmp_conan_profile
}

