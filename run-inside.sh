#!/bin/bash -eux

kversion="$(uname -r)"
export DOCKER_BUILDKIT=1

build_pro_container() {
	docker build docker/pro-container \
		--secret id=pro-attach-config,src=docker/pro-container/pro-attach-config.yaml \
		--build-arg KERNEL_VERSION="$kversion" \
		-t pro-container:"$kversion" || true
}

download_pkg_and_deps() {
	# linux-headers-5.15.0-1050-realtime requires linux-realtime-headers-5.15.0-1050
	local pkg=$1
	apt-cache depends -i "$pkg" |
		awk '/Depends:/ {print $2}' |
		xargs  apt-get download && apt-get download "$pkg"
}

build_host_pkgs() {
	local context=docker/host-pkgs
	mkdir -p "${context}/headers/$kversion" && cd "$_"
	download_pkg_and_deps "linux-headers-${kversion}"
	cd -
	docker build $context --build-arg KERNEL_VERSION="$kversion" -t host-pkgs:"$kversion"
}

# pro-client fails with: Cannot install Real-time kernel on a container.
build_pro_container

build_host_pkgs

docker build -f docker/host-mount/Dockerfile / --build-arg KERNEL_VERSION="$kversion" -t host-mount:"$kversion"
docker build -f docker/host-mount/finner.Dockerfile / --build-arg KERNEL_VERSION="$kversion" -t host-mount-finner:"$kversion"

docker image ls

