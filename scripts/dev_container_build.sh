#!/bin/bash

source $(dirname $0)/dev_container_info.sh

# === Help info === 
showHelp() {
cat << EOF  
Usage: ./build.sh -v <version> -t <build-type> [-hd]

Available options:

-h, -help,          --help                  Display help
-t, -build-type,    --build-type            Build type [ Release | Debug | RelWithDebInfo | MinSizeRel ]. (Default: Release)

----------------------------------
Calling build.sh script without parameters will run the script with defaults:

--build-type=Release

EOF
}

# === Script args === 

options=$(getopt -l "help,build-type:" -o "ht:" -a -- "$@")

eval set -- "$options"

while true
do
case "$1" in
-h|--help) 
    showHelp
    exit 0
    ;;
-t|--build-type) 
    shift
    export BUILD_TYPE="$1"
    ;;
--)
    shift
    break;;
esac
shift
done




tmp_conan_profile=$PROJ_DIR/conanTmpProfile

echo "================ Conan install $BUILD_TYPE =================="

cp $CONAN_PROFILE $tmp_conan_profile

# todo Сделать скрипт генерации conanProfile файла (перейти на python)
# change conan profile
sed -i "s|^arch*=.*|arch=$ARCH|" "$tmp_conan_profile"
sed -i "s|^build_type*=.*|build_type=$BUILD_TYPE|" "$tmp_conan_profile"
sed -i "s|^compiler*=.*|compiler=$COMPILER|" "$tmp_conan_profile"
sed -i "s|^compiler.version*=.*|compiler.version=$COMPILER_VERSION|" "$tmp_conan_profile"
sed -i "s|^compiler.cppstd*=.*|compiler.cppstd=$COMPILER_CPPSTD|" "$tmp_conan_profile"

mkdir -p $CONAN_BUILD_DIR
conan install $PROJ_DIR --output-folder=$CONAN_BUILD_DIR --profile=conanTmpProfile --profile:build=conanTmpProfile
rm $tmp_conan_profile

echo "================ Build: $ARCH $BUILD_TYPE =================="

mkdir -p $DEV_CONT_BUILD_DIR
cd $DEV_CONT_BUILD_DIR
cmake $SOURCE_DIR -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_TOOLCHAIN_FILE="$CONAN_BUILD_DIR/conan_toolchain.cmake"
cmake --build .

echo "Copy \"$build_folder/$PROJ_NAME\" into \"$INSTALL_DIR\""
mkdir -p $INSTALL_DIR
cp $DEV_CONT_BUILD_DIR/$PROJ_NAME $INSTALL_DIR/$PROJ_NAME