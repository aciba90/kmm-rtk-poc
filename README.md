# Kernel Module Management with Real Time Kernel

This repo showcases how to use RTK headers within docker containers to compile code / kernel modules.

In particular, how to create
[kernel module management](https://github.com/kubernetes-sigs/kernel-module-management/tree/main)'s
[ModuleLoader images](https://github.com/kubernetes-sigs/kernel-module-management/blob/main/docs/mkdocs/documentation/module_loader_image.md).

See more info in the [docker](/docker) sub folders.

## Reproducing it

1. Install the dependencies `sudo snap install lxd && lxd init --minimal`.
2. Substitute `YOUR_PRO_TOKEN` with a Pro token entitled to use `realtime-kernel` in
[run.sh](/run.sh) and
[docker/pro-container/pro-attach-config](/docker/pro-container/pro-attach-config.yaml).
3. Execute `./run.sh`.
