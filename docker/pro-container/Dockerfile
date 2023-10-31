FROM ubuntu:jammy AS builder

RUN --mount=type=secret,id=pro-attach-config \
    apt-get update \
    && apt-get install --no-install-recommends -y ubuntu-advantage-tools ca-certificates \
        bc \
        bison \
        flex \
        libelf-dev \
        gnupg \
        wget \
        git \
        make \
        gcc \
    && pro attach --attach-config /run/secrets/pro-attach-config \
    && pro enable --access-only realtime-kernel \
    && apt-get upgrade -y \
    && apt-get install -y linux-headers-${KERNEL_VERSION} \
    && apt-get purge --auto-remove -y ubuntu-advantage-tools ca-certificates \
    && rm -rf /var/lib/apt/lists/*

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
