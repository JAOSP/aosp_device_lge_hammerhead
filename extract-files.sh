#!/bin/sh

VENDOR=lge
DEVICE=hammerhead

echo "Please wait..."
wget -nc -q https://dl.google.com/dl/android/aosp/hammerhead-mmb29x-factory-c6109f15.tgz
tar zxf hammerhead-mmb29x-factory-c6109f15.tgz
rm hammerhead-mmb29x-factory-c6109f15.tgz
cd hammerhead-mmb29x
unzip image-hammerhead-mmb29x.zip
cd ../
./simg2img hammerhead-mmb29x/system.img system.ext4.img
mkdir system
sudo mount -o loop -t ext4 system.ext4.img system

BASE=../../../vendor/$VENDOR/$DEVICE/proprietary
rm -rf $BASE/*

for FILE in `cat proprietary-blobs.txt | grep -v ^# | grep -v ^$ | sed -e 's#^/system/##g'| sed -e "s#^-/system/##g"`; do
    DIR=`dirname $FILE`
    if [ ! -d $BASE/$DIR ]; then
        mkdir -p $BASE/$DIR
    fi
    cp system/$FILE $BASE/$FILE

done

./setup-makefiles.sh

sudo umount system
rm -rf system
rm -rf hammerhead-mmb29x
rm system.ext4.img
