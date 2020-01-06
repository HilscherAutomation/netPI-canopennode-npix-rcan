#use armv7hf compatible base image
FROM balenalib/armv7hf-debian:buster-20191223

#dynamic build arguments coming from the /hook/build file
ARG BUILD_DATE
ARG VCS_REF

#metadata labels
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/HilscherAutomation/netPI-canopennode-npix-rcan" \
      org.label-schema.vcs-ref=$VCS_REF

#enable building ARM container on x86 machinery on the web (comment out next line if built on Raspberry)
RUN [ "cross-build-start" ]

#version
ENV HILSCHERNETPI_CANOPENNODE_NPIX_RCAN_VERSION 1.0.2

#labeling
LABEL maintainer="netpi@hilscher.com" \
      version=$HILSCHERNETPI_CANOPENNODE_NPIX_RCAN_VERSION \
      description="CANopen Node for NIOT-E-NPIX-RCAN"

#copy files
COPY "./init.d/*" /etc/init.d/

RUN apt-get update \
    && apt-get install -y openssh-server build-essential git can-utils \
    && echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && mkdir /var/run/sshd \
    && cd /root/ \
    && git clone https://github.com/CANopenNode/CANopenSocket \
    && cd CANopenSocket \
    && git submodule init \
    && git submodule update \
    && cd canopend \
    && make \
    && echo - > od4_storage \
    && echo - > od4_storage_auto \
    && rm -rf /var/lib/apt/lists/*

#set the entrypoint
ENTRYPOINT ["/etc/init.d/entrypoint.sh"]

#SSH port
EXPOSE 22

#set STOPSGINAL
STOPSIGNAL SIGTERM

#stop processing ARM emulation (comment out next line if built on Raspberry)
RUN [ "cross-build-end" ]
