Simple counter program to demonstrate gdb on

# Running the docker

```
git clone git@github.com:andyneff/hello-world-gdb.git .
docker run -it --rm --privileged -v `pwd`:/src:ro --name hello_gdb andyneff/hello-world-gdb
```

Attach with your *favorite* debugger

# Launch Debugging

Most debuggers are not going to support this gracefully, so the simplest thing to do is to
start the docker yourself, and compile the binary, and then launch via `docker exec`

```
docker run -it --rm --privileged -v `pwd`:/src:ro --name hello_gdb andyneff/hello-world-gdb sh
gcc /src/hello.cpp -o /hello.out
```

Launch with your *favorite* debugger using `docker exec -i {container name} sh -c` as a wrapper.

## Why --privileged?

`gdb` needs ptrace permissions. Getting these in a docker varies from OS to OS.
The easiest thing to do is just give it all permissions. However, if you want the
most secure option, you need to figure out what is right for your operating systems,
for example, on Ubuntu with apparmor you need:

- `--security-opt=seccomp:unconfined` : needed for --attach pid#
- `--security-opt apparmor:unconfined` : needed for --multi (not currently used)
- `--cap-add SYS_PTRACE` : needed for ptrace
