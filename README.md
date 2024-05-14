# example-microchip-sama7g54

Build with:
`docker build . -t microchip`

Run with:
`docker run -it -v $PWD/build:/buildroot-microchip/buildroot-at91/output/image microchip`

Inside the container:
```
cd buildroot-at91
BR2_EXTERNAL=../buildroot-external-microchip/ make sama7g5ek_headless_defconfig
```

If you need to modify build settings do
`make menuconfig`

Otherwise build the image with
`make -j $((`nproc` - 1))`

The resulting image will be `build/sdcard.img`.