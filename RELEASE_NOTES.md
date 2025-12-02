# v13.4.0 Release

## Toolchain Versions

- **GCC**: 13.4.0
- **glibc**: 2.39
- **musl**: 1.2.4
- **Binutils**: 2.43.1
- **Linux headers**: 6.6.67 LTS
- **GDB**: 13.2

## Companion Libraries

- GMP 6.3.0
- ISL 0.27
- MPC 1.3.1
- MPFR 4.2.2
- ZSTD 1.5.7
- ZLIB 1.3.1

## Sysroot Extra Libraries

- **OpenSSL**: 3.4.0 (libssl, libcrypto)
- **libuuid**: from util-linux 2.40.2

## Changes

- Upgraded from GCC 14.2.0 to 13.4.0 for macOS build compatibility
- Updated glibc from 2.17 to 2.39
- Updated binutils to 2.43.1
- Updated Linux headers to 6.6.67 LTS
- Added OpenSSL 3.4.0 to sysroot for TLS support
- Added libuuid to sysroot
- Fixed macOS build issues with system zlib
- Disabled libcc1 for macOS clang++ compatibility
- Disabled GDB Python support for Python 3.13 compatibility

## Available Targets

### GNU libc targets
- aarch64-unknown-linux-gnu
- x86_64-unknown-linux-gnu
- i686-unknown-linux-gnu
- armv7-unknown-linux-gnueabihf
- arm-unknown-linux-gnueabi
- arm-unknown-linux-gnueabihf
- mipsel-unknown-linux-gnu

### musl libc targets
- aarch64-unknown-linux-musl
- x86_64-unknown-linux-musl
- i686-unknown-linux-musl
- armv7-unknown-linux-musleabihf
- arm-unknown-linux-musleabihf

## Installation

```bash
brew tap leostera/macos-cross-toolchains
brew install aarch64-unknown-linux-gnu
```

## Build Status

- ✅ aarch64-unknown-linux-gnu (Apple Silicon) - Complete
- ⏳ Remaining targets building via CI
