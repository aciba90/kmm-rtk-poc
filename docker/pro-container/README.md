# pro-container

Enable Ubuntu Pro within a container and install the headers.

To build it:

```sh
docker build . \
    --secret id=pro-attach-config,src=pro-attach-config.yaml \
    --build-arg KERNEL_VERSION="$(uname -r)"
```

## Note

At the moment of writing, this approach fails because `pro enable realtime-kernel`
fails in containers with:

```txt
Cannot install Real-time kernel on a container.
```

This is limited by the pro client, because it does not make a lot of sense to install a kernel in a container,
but it could be extended to allow this use case (use the kernel headers to compile kernel modules).
