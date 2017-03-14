Simple counter program to demonstrate gdb on

# Run

```
git clone git@github.com:andyneff/hello-world-gdb.git .
docker run -it --rm --privileged -v `pwd`:/src:ro --name hello_gdb andyneff/hello-world-gdb
```

Attach with your *favorite* debugger

#Launch Debuging

Most debuggers are not going to support this gracefully, so the simplest thing to do is to
start the docker yourself, and compile the binary, and then launch via `docker exec`

```
docker run -it --rm --privileged -v `pwd`:/src:ro --name hello_gdb andyneff/hello-world-gdb sh
gcc /src/hello.cpp -o /hello.out
```

Launch with your *favorite* debugger using `docker exec -i {container name} sh -c` as a wrapper.
