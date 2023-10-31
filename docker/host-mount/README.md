# host-mount

This approach mounts the kernel headers from the host. To do so, it requires
`/usr/lib/modules` and `/usr/src` to be in the build context at build-time.

To run it:

```bash
kversion=$(uname -r)
docker build -f Dockerfile / --build-arg KERNEL_VERSION="$kversion" -t host-mount:"$kversion"
```

Note: `/` as build-context could be optimized / limited to use
`/usr/lib/modules` and `/usr/src` as
[multiple build context](https://www.docker.com/blog/dockerfiles-now-support-multiple-build-contexts/)
or being even more granular.
