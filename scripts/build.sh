#!/bin/bash

source $(dirname $0)/project_info.sh

# === Help info === 
showHelp() {
cat << EOF  
Usage: ./build.sh -v <version> -t <build-type> [-hd]

Available options:

-h, -help,          --help                  Display help
-a, -arch,          --arch                  Architecture [ x86_64 | armv7hf ]. (Default: x86_64)
-d, -docker,        --docker                Build and run in docker container.
-t, -build-type,    --build-type            Build type [ Release | Debug | RelWithDebInfo | MinSizeRel ]. (Default: Release)

----------------------------------
Calling build.sh script without parameters will run the script with defaults:

--arch=x86_64
--build-type=Release

EOF
}
# -v, -version,       --version               Project version.

# === Script args === 

export use_docker=false

# === Script args === 

options=$(getopt -l "help,arch:,docker,build-type:" -o "hv:a:dt:" -a -- "$@") #,version:

eval set -- "$options"

while true
do
case "$1" in
-h|--help) 
    showHelp
    exit 0
    ;;
# -v|--version) 
#     shift
#     export version="$1"
#     ;;
-a|--arch) 
    shift
    export ARCH="$1"
    ;;
-d|--docker) 
    export use_docker=true
    ;;
-t|--build-type) 
    shift
    export build_type="$1"
    ;;
--)
    shift
    break;;
esac
shift
done

# === Docker Variables === 
tag_num=2
# base_image_name=geosx/ubuntu20.04-gcc10:261-585
base_image_name=rockdreamer/ubuntu20-gcc10



if [ $ARCH == "x86_64" ]; then
  COMPILER=gcc
  COMPILER_VERSION=10
  CPPSTD_PREFIX=gnu
  tag_num=1
  # base_image_name=geosx/ubuntu20.04-gcc10:261-585
  base_image_name=rockdreamer/ubuntu20-gcc10
elif [ $ARCH == "armv7hf" ]; then
	COMPILER=gcc
	COMPILER_VERSION=10
  CPPSTD_PREFIX=gnu
	tag_num=2
	base_image_name=conanio/gcc10-armv7hf
fi


echo "================ $ARCH $BUILD_TYPE =================="
compiler_cppstd=$CPPSTD_PREFIX$CPP_STANDART

# change conan profile
sed -i "s|^arch*=.*|arch=$ARCH|" "$CONAN_PROFILE"
sed -i "s|^build_type*=.*|build_type=$BUILD_TYPE|" "$CONAN_PROFILE"
sed -i "s|^compiler*=.*|compiler=$COMPILER|" "$CONAN_PROFILE"
sed -i "s|^compiler.version*=.*|compiler.version=$COMPILER_VERSION|" "$CONAN_PROFILE"
sed -i "s|^compiler.cppstd*=.*|compiler.cppstd=$compiler_cppstd|" "$CONAN_PROFILE"

build_folder=$BUILD_DIR/local
if [ $use_docker == false ]; then
  build_folder=$BUILD_DIR/local/$BUILD_TYPE
  conan_folder=$BUILD_DIR/local/conan
  mkdir -p $build_folder
  mkdir -p $conan_folder

  conan install $PROJ_DIR --output-folder=$conan_folder --profile=conanProfile --profile:build=conanProfile
	# -s arch=x86_64 \
	# -s build_type=Debug \
	# -s compiler=gcc \
	# -s compiler.cppstd=gnu17 \
	# -s compiler.libcxx=libstdc++11 \
	# -s compiler.version=10 \
	# -s os=Linux \
	

  cd $build_folder
  cmake $SOURCE_DIR -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_TOOLCHAIN_FILE="$conan_folder/conan_toolchain.cmake"
	cmake --build .
else
  build_dir_name=docker/$COMPILER$COMPILER_VERSION-$ARCH/$BUILD_TYPE
  build_folder=$BUILD_DIR/$build_dir_name
  img_build_dir=/build
  img_name=img
  img_tag=$tag_num

  

#   [buildenv]
# CC=arm-linux-gnueabihf-gcc-10
# CXX=arm-linux-gnueabihf-g++-10
# LD=arm-linux-gnueabihf-ld


  mkdir -p $build_folder
  docker build --build-arg BASE_IMAGE="$base_image_name" --build-arg BUILD_TYPE="$BUILD_TYPE" --build-arg BUILD_FOLDER="$build_dir_name"  -t $img_name:$img_tag .
  docker run --rm -v $build_folder:$img_build_dir $img_name:$img_tag
fi


echo "================ Targets Install =================="
rm -rf install/*

collect_directories() {
    local dir="$1"
    local -n dir_array="$2"  # Используем ссылочный массив

    for item in "$dir"/*; do
        if [ -d "$item" ]; then
            dir_array+=("$(basename "$item")")  # Добавляем имя папки в массив
            # collect_directories "$item" dir_array  # Рекурсивный вызов для подкаталогов
        fi
    done
}

apps_directories=()
tests_directories=()
collect_directories "$build_folder/apps" apps_directories
collect_directories "$build_folder/tests" tests_directories

for dir in "${apps_directories[@]}"; do
    mkdir -p $INSTALL_DIR/apps/$dir
    echo "Install \"$dir\""
    echo "Copy \"$build_folder/apps/$dir/$dir\" into \"$INSTALL_DIR/apps/$dir/$dir\""
    cp $build_folder/apps/$dir/$dir $INSTALL_DIR/apps/$dir/$dir
done

for dir in "${tests_directories[@]}"; do
    directories=()
    collect_directories "$build_folder/tests/$dir" directories
    for subDir in "${directories[@]}"; do
        mkdir -p $INSTALL_DIR/tests/$dir/$subDir
        echo "Install \"$subDir\""
        echo "Copy \"$build_folder/tests/$dir/$subDir/$subDir\" into \"$INSTALL_DIR/tests/$dir/$subDir/$subDir\""
        cp $build_folder/tests/$dir/$subDir/$subDir $INSTALL_DIR/tests/$dir/$subDir/$subDir
    done
done

mkdir -p $UTILS_DIR/run
output_file="$UTILS_DIR/run/options"
> "$output_file" 

search_dir="$INSTALL_DIR/apps"
find "$search_dir" -type f -exec bash -c 'for file; do echo "[$(basename "$file")] $(dirname "$file")/$(basename "$file")" >> "$0"; done' "$output_file" {} +

search_dir="$INSTALL_DIR/tests"
find "$search_dir" -type f -exec bash -c 'for file; do echo "[$(basename "$file")] $(dirname "$file")/$(basename "$file")" >> "$0"; done' "$output_file" {} +
