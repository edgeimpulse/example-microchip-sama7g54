# example-microchip-sama7g54

Build with:
`docker build . -t microchip`

Run with:
`docker run -it -v $PWD/build:/buildroot-microchip/buildroot-at91/output/images microchip`

Inside the container, if you need to modify build settings do
`make menuconfig`

Otherwise proceed straight to building the image with
`make -j $((`nproc` - 1))`

The resulting image will be `build/sdcard.img`.