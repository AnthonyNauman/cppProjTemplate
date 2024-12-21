ARG BASE_IMAGE=geosx/ubuntu20.04-gcc10:261-585
ARG DEBIAN_FRONTEND=noninteractive


FROM ${BASE_IMAGE} AS build

ARG BUILD_TYPE=Release
ARG BUILD_FOLDER=build

USER root

RUN apt-get update && \
	apt-get install -y \
	cmake apt-utils python pip

# RUN python -m pip install --upgrade pip

RUN pip install conan==2.0 && conan profile detect --force
#&& conan profile detect --force


ADD ./ /tmp

WORKDIR /build_tmp

RUN conan install ../tmp \
	# -s arch=x86_64 \
	# -s build_type=Debug \
	# -s compiler=gcc \
	# -s compiler.cppstd=gnu17 \
	# -s compiler.libcxx=libstdc++11 \
	# -s compiler.version=10 \
	# -s os=Linux \
	--output-folder=../tmp/${BUILD_FOLDER}/conan --profile=../tmp/conanProfile --profile:build=../tmp/conanProfile

RUN  cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DCMAKE_TOOLCHAIN_FILE="../tmp/${BUILD_FOLDER}/conan/conan_toolchain.cmake" ../tmp/apps/app && cmake --build .

CMD [ "cp", "-r", "-u", "./", "/build"]