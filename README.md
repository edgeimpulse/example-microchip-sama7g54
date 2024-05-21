# example-microchip-sama7g54
# Introduction

This repository contains:

- A Dockerfile to build an image which can be used as a container for running the Buildroot steps
- A Buildroot configuration file to setup the build to work with Edge Impulse

# Prerequisites

- An Edge Impulse account
- The Microchip [SAMA7G54-EK Evaluation Kit](https://www.microchip.com/en-us/development-tool/EV40E67A)

# Hardware Setup

Set [these jumpers](https://developerhelp.microchip.com/xwiki/bin/view/software-tools/32-bit-kits/sama7g54-ek/features/#jumpers) to the default settings:

![jumpers](https://developerhelp.microchip.com/xwiki/bin/download/software-tools/32-bit-kits/sama7g54-ek/features/WebHome/sama7g54-ek-jumpers.png?width=500&height=281&rev=1.1)

Provide power to the board [as described in the Microchip documentation](https://developerhelp.microchip.com/xwiki/bin/view/software-tools/32-bit-kits/sama7g54-ek/features/#power).

# Buildroot

Build with:
`docker build . -t microchip`

Run with:
`docker run -it -v $PWD/build:/buildroot-microchip/buildroot-at91/output/images microchip`

Change directory:
`cd buildroot-microchip/buildroot-at91/`

Inside the container, run this command:
`make menuconfig`
Make changes to config if necessary, otherwise, exit the menuconfig without changes.

Proceed to building the image with
```make -j $((`nproc` - 1))```

The resulting image will be `build/sdcard.img`.

Further documentation on building Linux images for these devices is [available at Microchip](https://developerhelp.microchip.com/xwiki/bin/view/software-tools/32-bit-kits/sama7g54-ek/booting-linux-image/).

# Connecting the EVK

The Microchip Developer Help portal has documentation for [serial communications to the SAMA7G54-EK](https://developerhelp.microchip.com/xwiki/bin/view/software-tools/32-bit-kits/sama7g54-ek/console_serial_communications/). Once your serial terminal is connected make sure the device has power and press the `nStart` button, you should see messages appearing over the serial console.

Login with `root` user and `edgeimpulse` password.

If you would like to use SSH to connect to the board, some additional steps are necessary:

1.  `cd /etc/ssh/`
2.  `nano sshd_config`
3.  Uncomment and change `PermitRootLogin prohibit-password` to `PermitRootLogin yes`
4.  Uncomment `PasswordAuthentication yes`
5.  `CTRL+X` then `Y` then `Enter`
5.  `reboot` to restart SSH
6.  `ifconfig` to get IP address
7.  On host machine `ssh root@www.xxx.yyy.zzz`

Connect a webcam to the board and run `edge-impulse-linux`, and proceed to login and choose a project to connect the device.

Go to your studio project and start collecting data!

# Data Collection

# Model Training

# Deployment

# Running your Impulse