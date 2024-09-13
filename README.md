Simple counter program to demonstrate gdb in docker

# Running the docker

```
git clone git@github.com:andyneff/hello-world-gdb.git .
docker run -it --rm --privileged -v `pwd`:/src:ro --name hello_gdb andyneff/hello-world-gdb
```

# Launch Debugging

Most debuggers are not going to support this gracefully, so the simplest thing to do is to
start the docker yourself, and compile the binary, and then launch via `docker exec`


## Start process

### Use docker

#### Simple

#### Allow you to edit hello.c

```
docker run -it --rm --privileged -v `pwd`:/src:ro --name hello_gdb andyneff/hello-world-gdb:debian # Debian
docker run -it --rm --privileged -v `pwd`:/src:ro --name hello_gdb andyneff/hello-world-gdb:ubuntu # Ubuntu 22.04
docker run -it --rm --privileged -v `pwd`:/src:ro --name hello_gdb andyneff/hello-world-gdb:alpine # Alpine
```

### Use docker compose

```
docker compose run --rm --name hello_gdb debian # Debian
docker compose run --rm --name hello_gdb ubuntu # Ubuntu 22.04
docker compose run --rm --name hello_gdb alpine # Alpine
```

It should start printing out the container pid, usually around 12

Attach with your *favorite* debugger.

### Podman

Podman should work the same way, but is untested. Uou just need to replace the words `docker` with `podman`.

### Using singularity/apptainer

Singularity doesn't instance containers in the exact same way as docker. There is no `singularity container ps` or an `exec` that runs in the same container.

I do not know how you would make this work currently. Neither `run`/`exec` nor `instance start`/`instance run` give a way to run a _second_ executable in the container, which is crucial for this. The pid that will be reported in a normal `singularity run` command will print out the real pid, which if you can get GDB to attach to, but I can't figure out how to get VSCode to not freeze.

## Using VSCode - With Microsoft Remote Extension

After this repo was created, Microsoft continued to develop the Remote Extension to be easier to use. It is actually a smoother process, but it might not always fit in with your development pattern. So pick what's best for you.

## Using VSCode - Without Microsoft Remote Extension (The original method)

The included `launch.json` will automatically allow you to attach the VSCode using the "Microsoft C/C++ Extension"

1. Click the 🪲▶️ button on the Primary Sidebar on the left for the debugger extension.
2. Select "C++ Attach in hello_gdb container" on the left.
3. Press the ▶️ button to attach.
4. Vscode will list the PIDs in the container, and you need to pick the one for the c program (Which is why I have it print it's PID every second). It should be trivial to be able to determine this without that.
5. Press the ⏸️ button when you would like to start stepping through the process
6. Hover over the `x` variable, and you should see the value

## Attaching in other debuggers

If your debugger supports specifying the `gdb` executable, you can try pointing it to
- `docker exec -i {container name} /usr/bin/gdb` as a wrapper
- or `docker exec -i {container name} bash -c '/usr/bin/gdb ${1} /usr/bin/gdb` if the
  debugger sends multiple arguments as one single argument.

However if your debugger only supports "one" argument (with no spaces), you will have to save this to a script:

```bash
#!/usr/bin/env bash

docker exec -it hello_gdb /usr/bin/gdb "${@}"
```

The clear downside to this is hard coding the container name.

# FAQ

## How does this work?

Magic

## Why --privileged?

`gdb` needs ptrace permissions. Getting these in a docker varies from OS to OS.
The easiest thing to do is just give it all permissions. However, if you want the
most secure option, you need to figure out what is right for your operating systems,
for example, on Ubuntu with apparmor you need:

- `--security-opt=seccomp:unconfined` : needed for --attach pid#
- `--security-opt apparmor:unconfined` : needed for --multi (not currently used)
- `--cap-add SYS_PTRACE` : needed for ptrace
