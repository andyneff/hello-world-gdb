FROM debian:latest
MAINTAINER Andrew Neff <andrew.neff@visionsystemsinc.com>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gcc gdb libc6-dev && \
    rm -r /var/lib/apt/lists/*

CMD gcc /src/hello.c -g -o /hello.out && \
    /hello.out