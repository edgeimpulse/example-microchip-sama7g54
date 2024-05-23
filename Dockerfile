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

RUN cd buildroot-microchip/buildroot-at91 \
    && BR2_EXTERNAL=../buildroot-external-microchip/ make sama7g5ek_headless_defconfig

# copy the buildroot configuration file
COPY buildroot-config /buildroot-microchip/buildroot-at91/.config

# insert NODEJS_CPU = armv7 in the nodejs.mk file
RUN sed -i '16i NODEJS_CPU = armv7' /buildroot-microchip/buildroot-at91/package/nodejs/nodejs.mk

# insert example-standalone-inferencing-linux in the Config.in file
RUN sed -i 's/menu "Miscellaneous"/menu "Miscellaneous"\n	source "package\/example-standalone-inferencing-linux\/Config.in"/g' /buildroot-microchip/buildroot-at91/package/Config.in

# git clone the example-standalone-inferencing-linux repository and switch to profiling branch
RUN cd /buildroot-microchip/buildroot-at91/package \
    && git clone https://github.com/edgeimpulse/example-standalone-inferencing-linux.git profiler \
    && cd profiler \
    && git switch profiling

# paste the files into the package
COPY Config.in /buildroot-microchip/buildroot-at91/package/example-standalone-inferencing-linux/
COPY example-standalone-inferencing-linux.mk /buildroot-microchip/buildroot-at91/package/example-standalone-inferencing-linux/