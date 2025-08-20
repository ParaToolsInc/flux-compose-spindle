ARG flux_sched_version=jammy
FROM fluxrm/flux-sched:${flux_sched_version} AS builder
ARG replicas=3
ENV workers=${replicas}
USER root

RUN apt-get update
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
    openmpi-common \
    openmpi-bin \
    libopenmpi-dev \
    libgcrypt20 \
    libgcrypt20-dev \
    software-properties-common

RUN sh -c "printf \"fluxuser ALL=(ALL) NOPASSWD: ALL\\n\" >> /etc/sudoers"

# These are the STATE_DIR, system, and resources directories
ENV STATE_DIR=/var/lib/flux
RUN mkdir -p ${STATE_DIR} /etc/flux/system /etc/flux/system/cron.d /etc/flux/config /run/flux && \
    mkdir -p /etc/flux/system/cron.d && \
    mkdir -p /mnt/curve && \
    flux keygen /mnt/curve/curve.cert && \
    flux R encode --hosts="node-[1-${workers}]" > /etc/flux/system/R && \
    chown -R fluxuser:fluxuser /run/flux ${STATE_DIR} /mnt/curve/curve.cert ${workdir}

RUN git clone https://github.com/hpc/Spindle.git /home/fluxuser/Spindle && \
    mkdir -p /home/fluxuser/Spindle-build && \
    cd /home/fluxuser/Spindle-build && \
    ../Spindle/configure --prefix=/home/fluxuser/Spindle-inst --enable-sec-munge --with-rm=flux --enable-flux-plugin --with-localstorage=/tmp && \
    make -j8 && \
    make install

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
ENV PATH /home/fluxuser/Spindle-inst/bin:$PATH
ENTRYPOINT /bin/bash /home/fluxuser/entrypoint.sh
