#!/bin/bash

source $(dirname $0)/project_info.sh

# === Help info === 
showHelp() {
cat << EOF  
Usage: ./build.sh -v <version> -t <build-type> [-hd]

Available options:

-h, -help,          --help                  Display help
-t, -build-type,    --build-type            Build type [ Release | Debug | RelWithDebInfo | MinSizeRel ]. (Default: Release)
-t, -build-targets, --build-targets         Build targets [ Apps | Tests | All ]. (Default: Apps)
-d, -docker,        --docker                Build and run in docker container.
-a, -arch,          --arch                  Architecture [ x86_64 | armv7hf ]. (Default: x86_64)

----------------------------------
Calling build.sh script without parameters will run the script with defaults:

--build-type=Release
--build-targets=Apps
--arch=x86_64

EOF
}

# === Script args === 

options=$(getopt -l "help,build-type:,build-targets:,docker,arch:" -o "hb:t:da:" -a -- "$@")

eval set -- "$options"

while true
do
case "$1" in
-h|--help) 
    showHelp
    exit 0
    ;;
-b|--build-type) 
    shift
    export BUILD_TYPE="$1"
    ;;
-t|--build-targets) 
    shift
    export BUILD_TARGS="$1"
    if [ $BUILD_TARGS = "Tests" ] ; then
        export USE_CONAN=true
        export BUILD_TESTS=ON
        export BUILD_APPS=OFF
    elif [ $BUILD_TARGS = "All" ] ; then
        export USE_CONAN=true
        export BUILD_TESTS=ON
        export BUILD_APPS=ON
    elif [ $BUILD_TARGS = "Apps" ] ; then
        export BUILD_TESTS=OFF
        export BUILD_APPS=ON
    fi
    ;;
-d|--docker) 
    export USE_DOCKER=true
    ;;
-a|--arch) 
    shift
    export ARCH="$1"
    ;;
--)
    shift
    break;;
esac
shift
done

if [ $USE_DOCKER == true ]; then

    if [ $ARCH == "x86_64" ]; then
        tag_num=1
        DOCKER_FILE=$PROJ_DIR/Dockerfile
        CONAN_PROFILE=conanProfile
    elif [ $ARCH == "armv7hf" ]; then
        tag_num=2
        DOCKER_FILE=$PROJ_DIR/Dockerfile_armv7hf
        CONAN_PROFILE=conanProfile_armv7hf
    fi
    

    build_dir_name=build-$COMPILER$COMPILER_VERSION-$ARCH
    img_build_dir=/build
    img_name=img
    img_tag=$tag_num
    volume_folder=$BUILD_DIR-$COMPILER$COMPILER_VERSION-$ARCH

    mkdir -p $volume_folder

    docker build --build-arg BUILD_TYPE="$BUILD_TYPE" --build-arg BUILD_FOLDER="$build_dir_name" --build-arg BUILD_APPS=$BUILD_APPS --build-arg BUILD_TESTS=$BUILD_TESTS --build-arg CONAN_FILE_NAME="$CONAN_PROFILE" -t $img_name:$img_tag -f $DOCKER_FILE $PROJ_DIR
    
    docker run -v $volume_folder:$img_build_dir $img_name:$img_tag

    exit 0
fi


if [ $USE_CONAN = true ] ; then
    CONAN_PROFILE=$PROJ_DIR/conanProfile
    conan_install $ARCH $BUILD_TYPE $CONAN_PROFILE $PROJ_DIR $CONAN_BUILD_DIR
fi

mkdir -p $PROJ_BUILD_DIR 
cd $PROJ_BUILD_DIR

if [ $USE_CONAN = true ] ; then
    cmake $SOURCE_DIR -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DBUILD_TESTS=$BUILD_TESTS -DBUILD_APPS=$BUILD_APPS -DCMAKE_TOOLCHAIN_FILE="$CONAN_TOOLCHAIN"
else
    cmake $SOURCE_DIR -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DBUILD_TESTS=$BUILD_TESTS -DBUILD_APPS=$BUILD_APPS
fi

# Cmake build app
cmake --build . 


# [Optional] Save apps targets and tests to file for vscode tasks
if [ $USE_VSCODE = true ] ; then
    mkdir -p $VSCODE_DIR/run
    output_file="$VSCODE_DIR/run/options"
    > "$output_file"
fi


if [ $BUILD_APPS = "ON" ] ; then
    echo "================ $PROJ_NAME Install =================="

    # [Optional] Copy target to install dir
    apps_directories=()
    collect_directories "$PROJ_BUILD_DIR/apps" apps_directories

    for dir in "${apps_directories[@]}"; do
        echo "Install \"$dir\""
        mkdir -p $INSTALL_DIR/apps/$dir
        echo "Copy \"$PROJ_BUILD_DIR/apps/$dir/$dir\" into \"$INSTALL_DIR/apps/$dir/$dir\""
        cp $PROJ_BUILD_DIR/apps/$dir/$dir $INSTALL_DIR/apps/$dir/$dir
    done

    # [Optional] Save apps targets to file for vscode tasks
    if [ $USE_VSCODE = true ] ; then
        search_dir="$INSTALL_DIR/apps"
        find "$search_dir" -type f -exec bash -c 'for file; do echo "[$(basename "$file")] $(dirname "$file")/$(basename "$file")" >> "$0"; done' "$output_file" {} +
    fi

fi

if [ $BUILD_TESTS = "ON" ] ; then
    
    # [Optional] Copy target to bin dir
    tests_directories=()
    collect_directories "$PROJ_BUILD_DIR/tests" tests_directories
    
    for dir in "${tests_directories[@]}"; do
        directories=()
        collect_directories "$PROJ_BUILD_DIR/tests/$dir" directories
        for subDir in "${directories[@]}"; do
            mkdir -p $INSTALL_DIR/tests/$dir/$subDir
            mkdir -p $ARTIFACTS_DIR/coverage/$dir/$subDir/

            echo "Install \"$subDir\""
            echo "Copy \"$PROJ_BUILD_DIR/tests/$dir/$subDir/$subDir\" into \"$INSTALL_DIR/tests/$dir/$subDir/$subDir\""
            cp $PROJ_BUILD_DIR/tests/$dir/$subDir/$subDir $INSTALL_DIR/tests/$dir/$subDir/$subDir
            cp -r $PROJ_BUILD_DIR/tests/$dir/$subDir/CMakeFiles/$subDir.dir/__/__/__/apps/$dir/src/* $ARTIFACTS_DIR/coverage/$dir/$subDir/
        done
    done

    # [Optional] Save apps targets to file for vscode tasks
    if [ $USE_VSCODE = true ] ; then
        search_dir="$INSTALL_DIR/tests"
        find "$search_dir" -type f -exec bash -c 'for file; do echo "[$(basename "$file")] $(dirname "$file")/$(basename "$file")" >> "$0"; done' "$output_file" {} +  
    fi

fi






