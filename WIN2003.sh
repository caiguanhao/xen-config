#!/bin/bash

set -e

NODE=d
TEMPLATE=WIN2003
MEMORY=3GiB
DISKNAME=DTP_Windows_2003_c
DISKSIZE=101GiB

echo Updating name of Xen host...

IFS=$' \t\n'
UUID=(`xe host-list | grep ^uuid | sed 's/.*: //'`)
if [[ ${#UUID[@]} -gt 1 ]]; then
  echo "Error: it should have one host. right?"
  exit 1
fi
OLDNAME=`xe host-param-get uuid=$UUID param-name=name-label`
IPADDR=`xe host-param-get uuid=$UUID param-name=address`
if [[ $IPADDR == "" ]]; then
  echo Getting IP address from ifconfig instead of xe command...
  IPADDR=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | \
          grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
fi
NEWNAME="$IPADDR"
xe host-param-set uuid=$UUID name-label=$NEWNAME

echo Name of Xen host has been changed from \"$OLDNAME\" to \"$NEWNAME\"...

echo Creating Storage...
LVNAME=CGH
VGNAME=`vgs | grep "VG_XenStorage" | cut -c 3-52`
lvcreate -L 35GB -n $LVNAME $VGNAME
mkfs.ext3 /dev/$VGNAME/$LVNAME
mkdir /$LVNAME
mount /dev/$VGNAME/$LVNAME /$LVNAME
cd /$LVNAME

echo Downloading OS...
curl -O http://$NODE.cgh.io/$TEMPLATE.7z

echo Extracting archive...
curl -sL "http://sourceforge.net/projects/p7zip/files/p7zip/9.20.1/"\
"p7zip_9.20.1_x86_linux_bin.tar.bz2/download" | tar jvfx - &&\
mv p7zip_9.20.1/bin 7z && rm -rf p7zip_9.20.1
./7z/7z x $TEMPLATE.7z

echo Importing Template...
xe vm-import filename=$TEMPLATE.xva
echo Template is imported.

echo Adjusting memory size...
IFS=$' \t\n'
UUID=(`xe template-list | grep $TEMPLATE -B 1 | grep ^uuid | sed 's/.*: //'`)

if [[ ${#UUID[@]} -gt 1 ]]; then
  echo "Error: more than one template matches \"$TEMPLATE\"."
  exit 1
fi
if [[ ${#UUID[@]} -lt 1 ]]; then
  echo "Error: no template matches \"$TEMPLATE\"."
  exit 1
fi

xe template-param-set \
   uuid=$UUID \
   memory-static-min=$MEMORY \
   memory-dynamic-min=$MEMORY \
   memory-dynamic-max=$MEMORY \
   memory-static-max=$MEMORY \
   2>/dev/null || \
xe template-param-set \
   uuid=$UUID \
   memory-static-max=$MEMORY \
   memory-dynamic-max=$MEMORY \
   memory-dynamic-min=$MEMORY \
   memory-static-min=$MEMORY

echo Memory adjusted.

echo Resizing user disk...
UUIDS=`xe vdi-list | grep $DISKNAME -B 1 -A 5 | grep ^uuid | sed 's/.*: //'`
IFS=$' \t\n'
UUID=(`for uuid in $UUIDS; \
       do xe vbd-list | grep $TEMPLATE -C 2 | grep $uuid -B 3 -A 1 | \
          sed -n 4p | sed 's/.*: //'; \
       done`)

if [[ ${#UUID[@]} -gt 1 ]]; then
  echo "Error: more than one vdi is found for:"
  echo "  disk \"$DISKNAME\" of \"$TEMPLATE\"."
  exit 1
fi
if [[ ${#UUID[@]} -lt 1 ]]; then
  echo "Error: no vdi is found for:"
  echo "  disk \"$DISKNAME\" of \"$TEMPLATE\"."
  exit 1
fi

xe vdi-resize uuid=$UUID disk-size=$DISKSIZE

echo User disk resized.

echo Done.
