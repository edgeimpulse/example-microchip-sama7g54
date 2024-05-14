FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    git \
    build-essential \
    libncurses-dev \
    wget cpio unzip rsync bc

# Add Ubuntu Toolchain PPA
RUN add-apt-repository ppa:ubuntu-toolchain-r/test

# Install GCC and G++
RUN apt-get update && apt-get install -y \
    gcc-10 \
    g++-10

# Set GCC and G++ alternatives
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 100

# Clone buildroot repositories
RUN mkdir buildroot-microchip \
    && cd buildroot-microchip \
    && git clone https://github.com/linux4microchip/buildroot-external-microchip.git -b 2023.02-mchp \
    && git clone https://github.com/linux4sam/buildroot-at91.git \
    && cd buildroot-at91 \
    && git checkout tags/linux4microchip-2024.04-rc1 -b 2023.02-mchp \
    && cd .. \
    && git clone https://github.com/linux4microchip/dt-overlay-mchp.git \
    && cd dt-overlay-mchp \
    && git checkout tags/linux4microchip-2024.04-rc1 -b 2023.02-mchp \
    && cd ..

# copy the buildroot configuration file
COPY buildroot-config /buildroot-microchip/buildroot-at91/.config

# insert NODEJS_CPU = armv7 in the nodejs.mk file
RUN sed -i '16i NODEJS_CPU = armv7' /buildroot-microchip/buildroot-at91/package/nodejs/nodejs.mk