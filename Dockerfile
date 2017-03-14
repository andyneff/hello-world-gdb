FROM alpine:latest
MAINTAINER Andrew Neff <andrew.neff@visionsystemsinc.com>

RUN apk add --no-cache gcc gdb musl-dev

CMD gcc /src/hello.c -g -o /hello.out && \
    /hello.out