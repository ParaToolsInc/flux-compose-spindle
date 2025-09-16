ARG flux_sched_version=jammy
FROM fluxrm/flux-sched:${flux_sched_version} AS builder
ARG replicas=3
ENV workers=${replicas}
USER root

RUN apt-get update
RUN apt-get upgrade -y 
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install \
    autotools-dev \
    autoconf \
    automake \
    cmake \
    git \
    python3 \
    openssh-server \
    openssh-client \
    libdb-dev \
    apt-utils \
    dnsutils \
    iputils-ping \
    python3-pip \
    libgcrypt20 \
    libgcrypt20-dev \
    gdb \
    software-properties-common

# Allow fluxuser to run as other users so it can start munged
RUN sh -c "printf \"fluxuser ALL=(ALL) NOPASSWD: ALL\\n\" >> /etc/sudoers"

# These are the STATE_DIR, system, and resources directories
ENV STATE_DIR=/var/lib/flux
RUN mkdir -p ${STATE_DIR} /etc/flux/system /etc/flux/system/cron.d /etc/flux/config /run/flux && \
    mkdir -p /etc/flux/system/cron.d && \
    mkdir -p /mnt/curve && \
    flux keygen /mnt/curve/curve.cert && \
    flux R encode --hosts="node-[1-${workers}]" > /etc/flux/system/R && \
    chown -R fluxuser:fluxuser /run/flux ${STATE_DIR} /mnt/curve/curve.cert ${workdir}

WORKDIR /home/fluxuser
RUN wget https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.5.1.tar.gz &&\
    tar xvzf osu-micro-benchmarks-7.5.1.tar.gz && \
    cd /home/fluxuser/osu-micro-benchmarks-7.5.1 && \
    ./configure CC=mpicc CXX=mpicxx && \
    make -j8 && \
    make install

WORKDIR /home/fluxuser
COPY scripts/build_spindle.sh /home/fluxuser/build_spindle.sh
RUN ./build_spindle.sh

WORKDIR /home/fluxuser
RUN pip3 install --upgrade pip && \
    chown -R fluxuser:fluxuser /home/fluxuser && \
    chown -R fluxuser:fluxuser /run/flux && \
    mkdir -p /shared && \
    chown -R fluxuser:fluxuser /shared && \
    mkdir -p /code/workdir && \
    chown -R fluxuser:fluxuser /code/workdir


USER fluxuser
WORKDIR /home/fluxuser/
COPY ./scripts/entrypoint.sh ./
COPY ./examples ./examples
ENV PATH /home/fluxuser/Spindle-inst/bin:$PATH
ENV HWLOC_HIDE_ERRORS 2
ENV RDMAV_FORK_SAFE 1
ENTRYPOINT /bin/bash /home/fluxuser/entrypoint.sh
