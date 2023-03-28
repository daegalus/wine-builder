#!/bin/sh

BUILD_THREADS="${BUILD_THREADS:-4}"
echo "Using $BUILD_THREADS threads for build."

# Prepare the build environment
mkdir -p wine32-build wine64-build 
sudo mkdir -p wine-src/wine-install


# Build 64-bit Wine
sudo apt install -y samba-dev libcups2-dev
cd wine64-build
../wine-src/configure --prefix=/wine-builder/wine-src/wine-install --enable-win64
make -j$BUILD_THREADS

# Build 32-bit Wine
sudo apt install -y samba-dev:i386 libcups2-dev:i386
cd ../wine32-build
PKG_CONFIG_PATH=/usr/lib/pkgconfig ../wine-src/configure --with-wine64=../wine64-build --prefix=/wine-builder/wine-src/wine-install
make -j$BUILD_THREADS

# Install Wine
sudo make install -j$BUILD_THREADS
cd ../wine64-build
sudo make install -j$BUILD_THREADS

echo "Build complete, final output is in 'wine-install'"