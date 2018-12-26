FROM arm32v7/debian:9
MAINTAINER @kroschu <>

ARG IPFS_VERSION=0.4.18
ARG ARCH=arm
ARG IPFS_URL=https://ipfs.io/ipns/dist.ipfs.io/go-ipfs/v${IPFS_VERSION}/go-ipfs_v${IPFS_VERSION}_linux-${ARCH}.tar.gz

RUN apt update && \
    apt install -y wget && \
    wget $IPFS_URL && \
    tar xzf go-ipfs_v${IPFS_VERSION}_linux-${ARCH}.tar.gz


FROM arm32v7/busybox:glibc
MAINTAINER @kroschu <>

ENV IPFS_PATH /data/.ipfs
ENV IPFS_STORAGE_MAX 2G
ENV IPFS_ANNOUNCE []

COPY --from=0 /go-ipfs/ipfs /usr/local/bin/ipfs
COPY --from=0 /etc/ssl/certs /etc/ssl/certs

COPY entrypoint.sh /entrypoint.sh 

EXPOSE 4001
EXPOSE 4002/udp
EXPOSE 5001
EXPOSE 8080
EXPOSE 8081

ENTRYPOINT ["./entrypoint.sh"]
