ARG ubuntu_version=noble
FROM ubuntu:${ubuntu_version}
USER root

RUN DEBIAN_FRONTEND="noninteractive" apt-get update \
# install latest pkg utils:
 && apt-get -qq install -y --no-install-recommends \
        apt-utils \
 && apt-get -qq install -y --no-install-recommends \
        locales \
        ca-certificates \
        wget \
        man \
        git \
        flex \
        ssh \
        sudo \
        vim \
        luarocks \
        munge \
        lcov \
        ccache \
        lua5.2 \
        lua5.2-posix-dev \
        valgrind \
        jq \
        build-essential \
        pkg-config \
        autotools-dev \
        libtool \
        autoconf \
        automake \
        make \
        cmake \
        ninja-build \
        gfortran \
        clang-18 \
        clang-tools-18 \
        gcc-13 \
        g++-13 \
        gcc-14 \
        g++-14 \
        gdb \
        libffi-dev \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        libsodium-dev \
        libzmq3-dev \
        libjansson-dev \
        libmunge-dev \
        libncursesw5-dev \
        liblua5.2-dev \
        liblz4-dev \
        libsqlite3-dev \
        uuid-dev \
        libhwloc-dev \
        libevent-dev \
        libarchive-dev \
        libpam-dev \
        libpmix-dev \
        time \
        openssh-server \
        openssh-client \
        libdb-dev \
        dnsutils \
        iputils-ping \
        libgcrypt20 \
        libgcrypt20-dev \
        silversearcher-ag \
        fd-find \
        software-properties-common

COPY scripts/fetch-and-build-mpich.sh /fetch-and-build-mpich.sh
RUN /fetch-and-build-mpich.sh

ENV HWLOC_COMPONENTS=-gl

RUN mkdir -p /run/munge && \
    chown munge:munge /run/munge && \
    chmod 0755 /run/munge

ARG USER=spindleuser
ARG UID=1001
COPY scripts/add_docker_user.sh /add_docker_user.sh
RUN /add_docker_user.sh

USER $USER
WORKDIR /home/$USER
COPY scripts/build_spindle.sh /home/$USER/build_spindle.sh
RUN ./build_spindle.sh

COPY ./scripts/entrypoint.sh /home/$USER/entrypoint.sh
ENV PATH /home/$USER/Spindle-inst/bin:$PATH
ENV LD_LIBRARY_PATH /usr/lib:$LD_LIBRARY_PATH
COPY ./examples/mpi-hello.c ./
ENTRYPOINT /bin/bash ./entrypoint.sh

