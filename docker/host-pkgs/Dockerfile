FROM ubuntu:jammy as builder

ARG KERNEL_VERSION

COPY headers/${KERNEL_VERSION}/* /tmp/headers/${KERNEL_VERSION}/
RUN apt-get update && apt-get install -y bc \
    bison \
    flex \
    libelf-dev \
    gnupg \
    wget \
    git \
    make \
    gcc \
    /tmp/headers/${KERNEL_VERSION}/*.deb

WORKDIR /usr/src
RUN ["git", "clone", "https://github.com/kubernetes-sigs/kernel-module-management.git"]

WORKDIR /usr/src/kernel-module-management/ci/kmm-kmod
RUN ["bash", "-c", "make"]

FROM ubuntu:jammy

ARG KERNEL_VERSION

RUN apt-get update && apt-get install -y kmod

COPY --from=builder /usr/src/kernel-module-management/ci/kmm-kmod/kmm_ci_a.ko /opt/lib/modules/${KERNEL_VERSION}/
COPY --from=builder /usr/src/kernel-module-management/ci/kmm-kmod/kmm_ci_b.ko /opt/lib/modules/${KERNEL_VERSION}/

RUN depmod -b /opt ${KERNEL_VERSION}
