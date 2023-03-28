FROM debian:11-slim

ARG USERNAME=wine-builder
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install 32-bit Architecture
RUN dpkg --add-architecture i386

# Make sure everythng is up to date
RUN apt update && apt upgrade -y && apt autoremove -y

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

# Install core system packages
RUN sudo apt install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    build-essential:amd64

# Install Necessary 64-bit Dependencies
RUN sudo apt install -y --no-install-recommends \
    gcc-multilib \
    gcc-mingw-w64 \
    libasound2-dev \
    libpulse-dev \
    libdbus-1-dev \
    libfontconfig-dev \
    libfreetype-dev \
    libgnutls28-dev \
    libgl-dev \
    libunwind-dev \
    libx11-dev \
    libxcomposite-dev \
    libxcursor-dev \
    libxfixes-dev \
    libxi-dev \
    libxrandr-dev \
    libxrender-dev \
    libxext-dev

# Install Recommended 64-bit Depenendencies
RUN sudo apt install -y --no-install-recommends \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libosmesa6-dev \
    libsdl2-dev \
    libudev-dev \
    libvulkan-dev

# Install Optional 64-bit Dependencies
RUN sudo apt install -y --no-install-recommends \
    libcapi20-dev \
    libcups2-dev \
    libgphoto2-dev \
    libsane-dev \
    libkrb5-dev \
    samba-dev \
    ocl-icd-opencl-dev \
    libpcap-dev \
    libusb-1.0-0-dev \
    libv4l-dev

# Install Necessary 32-bit Dependencies
RUN sudo apt install -y --no-install-recommends \
    gcc-multilib:i386 \
    libasound2-dev:i386 \
    libpulse-dev:i386 \
    libdbus-1-dev:i386 \
    libfontconfig-dev:i386 \
    libfreetype-dev:i386 \
    libgnutls28-dev:i386 \
    libgl-dev:i386 \
    libunwind-dev:i386 \
    libx11-dev:i386 \
    libxcomposite-dev:i386 \
    libxcursor-dev:i386 \
    libxfixes-dev:i386 \
    libxi-dev:i386 \
    libxrandr-dev:i386 \
    libxrender-dev:i386 \
    libxext-dev:i386

# Install Recommended 32-bit Depenendencies
RUN sudo apt install -y --no-install-recommends \
    libgstreamer1.0-dev:i386 \
    libgstreamer-plugins-base1.0-dev:i386 \
    libosmesa6-dev:i386 \
    libsdl2-dev:i386 \
    libudev-dev:i386 \
    libvulkan-dev:i386

# Install Optional 32-bit Dependencies
RUN sudo apt install -y --no-install-recommends \
    libcapi20-dev:i386 \
    libcups2-dev:i386 \
    libgphoto2-dev:i386 \
    libsane-dev:i386 \
    libkrb5-dev:i386 \
    samba-dev:i386 \
    ocl-icd-opencl-dev:i386 \
    libpcap-dev:i386 \
    libusb-1.0-0-dev:i386 \
    libv4l-dev:i386

COPY --chown=$USER_UID:$USER_GID build-wine.sh /build-wine.sh
RUN sudo chmod 777 /build-wine.sh

WORKDIR /wine-builder
RUN sudo chown $USER_UID:$USER_GID /wine-builder
RUN sudo chmod 777 /wine-builder

RUN sudo apt install -y build-essential flex bison lib32z1 gcc-multilib g++-multilib

ENTRYPOINT [ "/build-wine.sh" ]