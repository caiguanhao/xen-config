#!/bin/bash

NODE=d

echo Creating Storage...
LVNAME=CGH
VGNAME=`vgs | grep "VG_XenStorage" | cut -c 3-52`
lvcreate -L 35GB -n $LVNAME $VGNAME
mkfs.ext3 /dev/$VGNAME/$LVNAME
mkdir /$LVNAME
mount /dev/$VGNAME/$LVNAME /$LVNAME
cd /$LVNAME

echo Downloading OS...
curl -O http://$NODE.cgh.io/WIN2003.7z

echo Extracting archive...
curl -sL "http://sourceforge.net/projects/p7zip/files/p7zip/9.20.1/"\
"p7zip_9.20.1_x86_linux_bin.tar.bz2/download" | tar jvfx - &&\
mv p7zip_9.20.1/bin 7z && rm -rf p7zip_9.20.1
./7z/7z x WIN2003.7z

echo Importing Template...
xe vm-import filename=WIN2003.xva

echo Done.
