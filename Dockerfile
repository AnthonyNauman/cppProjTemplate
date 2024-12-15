ARG BASE_IMAGE=geosx/ubuntu20.04-gcc10:261-585
ARG DEBIAN_FRONTEND=noninteractive


FROM ${BASE_IMAGE} AS build

ARG BUILD_TYPE=Release

USER root

RUN apt-get update && \
	apt-get install -y \
	cmake apt-utils

ADD ./apps/app /app

WORKDIR /tmp

RUN cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} ../app && cmake --build .

CMD [ "cp", "-r", "-u", "./", "/build"]