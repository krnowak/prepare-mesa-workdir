#!/usr/bin/bash

set -e -v -x

d="$(dirname $0)"
b="${d}/build"

mkdir -p "${b}"

cd "${b}"

../src/configure --prefix="${HOME}/oglusr" --enable-debug \
	--enable-texture-float --enable-selinux --enable-dri3 --enable-osmesa \
	--enable-opengl --enable-gles1 --enable-gles2 --enable-dri \
	--enable-egl --enable-gbm --enable-xvmc --enable-vdpau --enable-omx \
	--enable-va --disable-xlib-glx --disable-r600-llvm-compiler \
	--enable-gallium-tests --enable-shared-glapi --enable-shader-cache \
	--enable-sysfs --enable-driglx-direct --enable-glx-tls \
	--disable-gallium-llvm --disable-llvm-shared-libs \
	--with-gallium-drivers=swrast --with-dri-drivers=swrast \
	--with-egl-platforms=x11,drm,wayland
