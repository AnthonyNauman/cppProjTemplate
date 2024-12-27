ARG DEBIAN_FRONTEND=noninteractive


FROM rockdreamer/ubuntu20-gcc10 AS build


ARG ARCH=x86_64


ARG BUILD_FOLDER=build
ARG CONAN_FILE_NAME=conanProfile

ARG CONAN_FOLDER=/tmp/${BUILD_FOLDER}/conan
ARG CONAN_FILE_PATH=/tmp/${CONAN_FILE_NAME}

USER root

RUN apt-get update && \
	apt-get install -y \
	cmake apt-utils python pip

RUN pip install conan==2.0 && conan profile detect --force

ADD ./ /tmp

ARG BUILD_TYPE=Release

WORKDIR /build_tmp/${BUILD_TYPE}

RUN conan install /tmp \
	--output-folder=${CONAN_FOLDER} \
	--profile=${CONAN_FILE_PATH} \
	--profile:build=${CONAN_FILE_PATH} \
	--build=missing

ARG BUILD_TESTS=ON
ARG BUILD_APPS=OFF

RUN  cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DBUILD_TESTS=${BUILD_TESTS} -DBUILD_APPS=${BUILD_APPS} -DCMAKE_TOOLCHAIN_FILE="/tmp/${BUILD_FOLDER}/conan/conan_toolchain.cmake" /tmp \
	&& cmake --build . 


CMD [ "cp", "-r", "-u", "./", "/build"]