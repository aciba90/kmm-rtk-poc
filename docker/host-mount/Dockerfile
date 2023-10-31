FROM ubuntu:jammy as builder

ARG KERNEL_VERSION

RUN apt-get update && apt-get install -y bc \
    bison \
    flex \
    libelf-dev \
    gnupg \
    wget \
    git \
    make \
    tree \
    gcc

RUN \
    --mount=target=/lib/modules,type=bind,source=lib/modules,readonly \
    --mount=target=/usr/src/,type=bind,source=usr/src/,readonly \
    git clone https://github.com/kubernetes-sigs/kernel-module-management.git /tmp/kmm && \
    cd /tmp/kmm/ci/kmm-kmod && \
    bash -c 'make'

FROM ubuntu:jammy

ARG KERNEL_VERSION

RUN apt-get update && apt-get install -y kmod

COPY --from=builder /tmp/kmm/ci/kmm-kmod/kmm_ci_a.ko /opt/lib/modules/${KERNEL_VERSION}/
COPY --from=builder /tmp/kmm/ci/kmm-kmod/kmm_ci_b.ko /opt/lib/modules/${KERNEL_VERSION}/

RUN depmod -b /opt ${KERNEL_VERSION}
