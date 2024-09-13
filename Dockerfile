ARG OS=debian
FROM ${OS}

MAINTAINER Andrew Neff <andrew.neff@visionsystemsinc.com>

SHELL ["/usr/bin/env", "sh", "-euxvc"]

RUN if command -v apk >/dev/null 2>/dev/null; then \
      apk add --no-cache gcc gdb bash musl-dev; \
    else \
      apt-get update; \
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
           gcc gdb procps libc6-dev; \
      rm -r /var/lib/apt/lists/*; \
    fi

ADD hello.c /src/hello.c

CMD gcc /src/hello.c -g -o /tmp/hello.out && \
    /tmp/hello.out