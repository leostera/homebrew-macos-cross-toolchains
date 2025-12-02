#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
TARGET=$1
JOBS=${2:-$(($(nproc) - 1))}

if [ -z "$TARGET" ]; then
    echo -e "${RED}Usage: $0 <target-triple> [jobs]${NC}"
    echo "Available targets:"
    echo "  - aarch64-unknown-linux-gnu"
    echo "  - aarch64-unknown-linux-musl"
    echo "  - x86_64-unknown-linux-gnu"
    echo "  - x86_64-unknown-linux-musl"
    echo "  - i686-unknown-linux-gnu"
    echo "  - i686-unknown-linux-musl"
    echo "  - arm-unknown-linux-gnueabi"
    echo "  - arm-unknown-linux-gnueabihf"
    echo "  - arm-unknown-linux-musleabihf"
    echo "  - armv7-unknown-linux-gnueabihf"
    echo "  - armv7-unknown-linux-musleabihf"
    echo "  - mipsel-unknown-linux-gnu"
    echo ""
    echo "Example: $0 aarch64-unknown-linux-gnu"
    exit 1
fi

if [ ! -d "$TARGET" ]; then
    echo -e "${RED}Error: Target directory '$TARGET' not found${NC}"
    exit 1
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Building Cross-Compilation Toolchain${NC}"
echo -e "${GREEN}========================================${NC}"
echo "Target: $TARGET"
echo "Jobs: $JOBS"
echo ""

# Check dependencies
echo -e "${YELLOW}[1/7] Checking dependencies...${NC}"
if ! command -v ct-ng &> /dev/null; then
    echo -e "${RED}Error: crosstool-ng not found${NC}"
    echo "Install with: brew install --HEAD crosstool-ng"
    exit 1
fi

if ! command -v wget &> /dev/null; then
    echo -e "${YELLOW}Installing wget...${NC}"
    brew install wget
fi

# Clean environment
echo -e "${YELLOW}[2/7] Cleaning environment variables...${NC}"
unset LIBRARY_PATH LD_LIBRARY_PATH CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH

# Create/attach volumes
echo -e "${YELLOW}[3/7] Setting up build volumes...${NC}"

# Check if volumes are already attached
if [ ! -d /Volumes/build ]; then
    if [ ! -f build.dmg.sparseimage ]; then
        echo "Creating build volume (16GB)..."
        hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 16g -volname build build.dmg
    fi
    echo "Attaching build volume..."
    hdiutil attach build.dmg.sparseimage
else
    echo "Build volume already attached"
fi

if [ ! -d /Volumes/tools ]; then
    if [ ! -f tools.dmg.sparseimage ]; then
        echo "Creating tools volume (1GB)..."
        hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 1g -volname tools tools.dmg
    fi
    echo "Attaching tools volume..."
    hdiutil attach tools.dmg.sparseimage
else
    echo "Tools volume already attached"
fi

# Create source directory
mkdir -p /Volumes/build/src

# Clean previous build
echo -e "${YELLOW}[4/7] Cleaning previous build artifacts...${NC}"
cd "$TARGET"
rm -rf .build
rm -f build.log
cd ..

# Build toolchain
echo -e "${YELLOW}[5/7] Building cross-compilation toolchain...${NC}"
echo "This will take 20-40 minutes depending on your machine..."
cd "$TARGET"
ct-ng build -j "$JOBS"
BUILD_STATUS=$?
cd ..

if [ $BUILD_STATUS -ne 0 ]; then
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}Toolchain build FAILED!${NC}"
    echo -e "${RED}========================================${NC}"
    echo "Check the build log: $TARGET/build.log"
    echo "Last 100 lines:"
    tail -n 100 "$TARGET/build.log"
    exit 1
fi

echo -e "${GREEN}Toolchain build completed successfully!${NC}"

# Build extra libraries
echo -e "${YELLOW}[6/7] Building extra libraries (OpenSSL, libuuid)...${NC}"
SYSROOT="/Volumes/tools/$TARGET/$TARGET/sysroot"

if [ ! -f build-extra-libs.sh ]; then
    echo -e "${RED}Error: build-extra-libs.sh not found${NC}"
    exit 1
fi

chmod +x build-extra-libs.sh
./build-extra-libs.sh "$TARGET" "$SYSROOT" "$JOBS"
LIBS_STATUS=$?

if [ $LIBS_STATUS -ne 0 ]; then
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}Extra libraries build FAILED!${NC}"
    echo -e "${RED}========================================${NC}"
    exit 1
fi

echo -e "${GREEN}Extra libraries build completed successfully!${NC}"

# Package toolchain
echo -e "${YELLOW}[7/7] Packaging toolchain...${NC}"
cd /Volumes/tools
ARCH=$(uname -m)
TARBALL="${TARGET}-${ARCH}-darwin.tar.gz"
tar czf "$TARBALL" "$TARGET"
mv "$TARBALL" ~/Desktop/
cd -

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Build completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Toolchain location: /Volumes/tools/$TARGET"
echo "Sysroot location: $SYSROOT"
echo "Tarball saved to: ~/Desktop/$TARBALL"
echo ""
echo "Installed libraries in sysroot:"
echo "  - glibc/musl (C library)"
echo "  - OpenSSL 3.4.0 (libssl, libcrypto)"
echo "  - libuuid (UUID support)"
echo ""
echo "To use the toolchain, add to PATH:"
echo "  export PATH=\"/Volumes/tools/$TARGET/bin:\$PATH\""
echo ""
echo "Example usage:"
echo "  ${TARGET}-gcc --version"
echo "  ${TARGET}-gcc -o hello hello.c"
echo ""
