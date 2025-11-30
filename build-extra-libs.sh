#!/bin/bash
set -e

# Configuration
TARGET=$1
SYSROOT=$2
JOBS=${3:-$(nproc)}

if [ -z "$TARGET" ] || [ -z "$SYSROOT" ]; then
    echo "Usage: $0 <target-triple> <sysroot-path> [jobs]"
    echo "Example: $0 aarch64-unknown-linux-gnu /Volumes/tools/aarch64-unknown-linux-gnu/aarch64-unknown-linux-gnu/sysroot 4"
    exit 1
fi

BUILD_DIR=/Volumes/build/extra-libs
SRC_DIR=/Volumes/build/src
mkdir -p "$BUILD_DIR" "$SRC_DIR"

# Set cross-compilation environment
export CC="${TARGET}-gcc"
export CXX="${TARGET}-g++"
export AR="${TARGET}-ar"
export RANLIB="${TARGET}-ranlib"
export STRIP="${TARGET}-strip"

echo "Building extra libraries for ${TARGET}"
echo "Installing to: ${SYSROOT}"

# Build libuuid (from util-linux)
echo "=== Building libuuid ==="
cd "$SRC_DIR"
if [ ! -d util-linux-2.40.2 ]; then
    wget -q https://www.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.2.tar.xz
    tar xf util-linux-2.40.2.tar.xz
fi
cd util-linux-2.40.2
mkdir -p "$BUILD_DIR/libuuid"
cd "$BUILD_DIR/libuuid"
"$SRC_DIR/util-linux-2.40.2/configure" \
    --host="$TARGET" \
    --prefix=/usr \
    --disable-all-programs \
    --enable-libuuid \
    --without-systemd \
    --without-python
make -j"$JOBS"
make DESTDIR="$SYSROOT" install

# Build OpenSSL
echo "=== Building OpenSSL ==="
cd "$SRC_DIR"
if [ ! -d openssl-3.4.0 ]; then
    wget -q https://www.openssl.org/source/openssl-3.4.0.tar.gz
    tar xf openssl-3.4.0.tar.gz
fi
cd openssl-3.4.0

# Determine OpenSSL target
case "$TARGET" in
    aarch64-*-linux-*)
        OPENSSL_TARGET="linux-aarch64"
        ;;
    x86_64-*-linux-*)
        OPENSSL_TARGET="linux-x86_64"
        ;;
    i686-*-linux-*)
        OPENSSL_TARGET="linux-x86"
        ;;
    arm-*-linux-*)
        OPENSSL_TARGET="linux-armv4"
        ;;
    armv7-*-linux-*)
        OPENSSL_TARGET="linux-armv4"
        ;;
    mipsel-*-linux-*)
        OPENSSL_TARGET="linux-mips32"
        ;;
    *)
        echo "Unknown target: $TARGET"
        exit 1
        ;;
esac

./Configure "$OPENSSL_TARGET" \
    --prefix=/usr \
    --openssldir=/etc/ssl \
    --cross-compile-prefix="${TARGET}-" \
    shared \
    no-tests
make -j"$JOBS"
make DESTDIR="$SYSROOT" install_sw install_ssldirs

echo "=== Extra libraries installed successfully ==="
echo "libuuid and OpenSSL 3.4.0 are now in ${SYSROOT}"
