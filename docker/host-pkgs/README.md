# host-packages

This approach downloads the required packages in the host and copies them to
the builder image.

To run it:

```bash
download_pkg_and_deps() {
    # linux-headers-5.15.0-1050-realtime requires linux-realtime-headers-5.15.0-1050
    local pkg=$1
    apt-cache depends -i "$pkg" |
        awk '/Depends:/ {print $2}' |
        xargs  apt-get download && apt-get download "$pkg"
}

kversion=$(uname -r)
mkdir -p "headers/$kversion" && cd "$_"
download_pkg_and_deps "linux-headers-${kversion}"
cd -

docker build . --build-arg KERNEL_VERSION="$kversion" -t host-pkgs:"$kversion"
```
