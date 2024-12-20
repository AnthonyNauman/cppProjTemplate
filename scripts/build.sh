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

export version=$PROJ_VERSION
export arch=x86_64
export use_docker=false
export build_type=Release

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
    export arch="$1"
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

# === Variables === 

docker_context=gcc10
compiler_version=10
tag_num=2
base_image_name=geosx/ubuntu20.04-gcc10:261-585
project_source_path=$SOURCE_DIR/$PROJ_NAME
install_folder=$(pwd)/install
build_type_docker="$build_type"

# === Variables === 

if [ $arch == "x86_64" ]; then
  docker_context=gcc10
  compiler_version=10
  tag_num=2
  base_image_name=geosx/ubuntu20.04-gcc10:261-585
elif [ $arch == "armv7hf" ]; then
	docker_context=gcc10
	compiler_version=10
	tag_num=1
	base_image_name=conanio/gcc10-armv7hf
	arch="armv7hf"
fi



echo "================ $arch $build_type =================="

if [ $use_docker == false ]; then
  build_folder=$(pwd)/build/local/$build_type
  mkdir -p $build_folder
  cd $build_folder
  cmake $project_source_path -DCMAKE_BUILD_TYPE=$build_type
	cmake --build .
else
  build_dir_name=$docker_context-$arch/$build_type
  build_folder=$BUILD_DIR/$build_dir_name
  img_build_dir=/build
  img_name=img
  img_tag=$tag_num


  mkdir -p $build_folder
  docker build --build-arg BASE_IMAGE="$base_image_name" --build-arg BUILD_TYPE="$build_type_docker"  -t $img_name:$img_tag .
  docker run --rm -v $build_folder:$img_build_dir $img_name:$img_tag
fi



echo "====== Copy $PROJ_NAME into $install_folder ======="
mkdir -p $install_folder
cp $build_folder/$PROJ_NAME $install_folder/$PROJ_NAME
