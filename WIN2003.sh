#!/bin/bash

set -e

copyright() {
  echo "Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)"
  echo "Licensed under the terms of the MIT license."
  echo "Report bugs on https://github.com/caiguanhao/xen-config/issues"
}

help() {
  echo "Usage: bash $0 [options]"
  echo "  --help, -h                Show this help and exit"
  echo "  --url, -u                 URL of the template to download"
  echo "                            default is $NODE_P$NODE_S<template-name>.7z"
  echo "                            If it is a number, like '2', it simply be:"
  echo "                            ${NODE_P}2$NODE_S<template-name>.7z"
  echo "  --password, -p <password> Use this password when extracting .7z"
  echo "  --template, -t <name>     Template name, default: $TEMPLATE"
  echo "  --disk, -l <name>         Disk name, default: $DISKNAME"
  echo "  --disksize, -d <size>     User disk size, default: $DISKSIZE"
  echo "  --memory, -m <size>       Memory size, default: $MEMORY"
  echo "  --number, -n <number>     Number of VMs to create, default: $VMNUMBER"
  echo "  --no-confirm, -y          Don't waste time to confirm"
  echo
  copyright
}

NODE_P="http://d"
NODE_S=".cgh.io/"
TEMPLATE=WIN2003
DISKNAME=DTP_Windows_2003_c
DISKSIZE=100GiB
MEMORY=3GiB
VMNUMBER=4
P7ZIPPASS=
NOCONFIRM=0

for arg in "$@"; do
  case "$arg" in
  -h|--help)       help && exit 0                      ;;
  -u|--url)        shift; OSURL="$1";            shift ;;
  -p|--password)   shift; P7ZIPPASS="-p\"$1\"";  shift ;;
  -t|--template)   shift; TEMPLATE="$1";         shift ;;
  -l|--disk)       shift; DISKNAME="$1";         shift ;;
  -d|--disksize)   shift; DISKSIZE="$1";         shift ;;
  -m|--memory)     shift; MEMORY="$1";           shift ;;
  -n|--number)     shift; VMNUMBER="$1";         shift ;;
  -y|--no-confirm) shift; NOCONFIRM=1;           shift ;;
  esac
done

case $OSURL in
  "")        OSURL="$NODE_P$NODE_S$TEMPLATE.7z"        ;;
  *[!0-9]*)                                            ;;
  *)         OSURL="$NODE_P$OSURL$NODE_S$TEMPLATE.7z"  ;;
esac

copyright

echo

if [[ $NOCONFIRM -eq 0 ]]; then
  echo Variables:
  echo Template name ........................... $TEMPLATE
  echo Change disk of this name ................ $DISKNAME
  echo Change user disk size to ................ $DISKSIZE
  echo Change memory size of template to ....... $MEMORY
  echo Number of VMs to create ................. $VMNUMBER
  echo URL of template to download ............. $OSURL
  echo
  echo "Operation starts in 10 seconds... Press Ctrl-C to Cancel"
  sleep 10
fi

# Update the name label of Xen host

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

if [[ $NEWNAME == $OLDNAME ]]; then
  echo No need to change the name of Xen host: \"$OLDNAME\"
else
  xe host-param-set uuid=$UUID name-label=$NEWNAME
  echo Name of Xen host has been changed from \"$OLDNAME\" to \"$NEWNAME\"...
fi


echo Creating Storage...
LVNAME=CGH
VGNAME=`vgs | grep "VG_XenStorage" | cut -c 3-52`
lvcreate -L 35GB -n $LVNAME $VGNAME
mkfs.ext3 /dev/$VGNAME/$LVNAME
mkdir /$LVNAME
mount /dev/$VGNAME/$LVNAME /$LVNAME
cd /$LVNAME

echo Downloading OS...
curl -LO $OSURL

echo Extracting archive...
curl -sL "http://sourceforge.net/projects/p7zip/files/p7zip/9.20.1/"\
"p7zip_9.20.1_x86_linux_bin.tar.bz2/download" | tar jvfx - &&\
mv p7zip_9.20.1/bin 7z && rm -rf p7zip_9.20.1
./7z/7z x $P7ZIPPASS $TEMPLATE.7z

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


echo Creating $VMNUMBER virtual machines from template...

if [[ $IPADDR == "" ]]; then
  IPADDR=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | \
          grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
fi
IPADDR1=${IPADDR%.*}
IPADDR2=${IPADDR##*.}
for i in `seq $VMNUMBER`; do
  NAME="$IPADDR1.$(($IPADDR2 + $i))"
  echo Creating new VM named \"$NAME\" from template \"$TEMPLATE\"...
  VMUUID=`xe vm-install new-name-label=$NAME template=$TEMPLATE`
  echo "VM \"$NAME\" created."

  echo "Modifying MAC address for VM \"$NAME\"..."
  VIFUUID=(`xe vif-list vm-uuid=$VMUUID | grep ^uuid | sed 's/.*: //'`)

  if [[ ${#VIFUUID[@]} -gt 1 ]]; then
    echo "Error: more than one vif is found for VM named \"$NAME\"."
    exit 1
  fi
  if [[ ${#VIFUUID[@]} -lt 1 ]]; then
    echo "Error: no vif is found for VM named \"$NAME\"."
    exit 1
  fi

  OLDMAC=`xe vif-param-get uuid=$VIFUUID param-name=MAC`
  NEWMAC="${OLDMAC:0:1}6${OLDMAC:2}"
  if [[ $NEWMAC == $OLDMAC ]]; then
    echo "No need to change Mac address."
  else
    DEVICE=`xe vif-param-get uuid=$VIFUUID param-name=device`
    NWUUID=`xe vif-param-get uuid=$VIFUUID param-name=network-uuid`
    xe vif-destroy uuid=$VIFUUID
    xe vif-create device=$DEVICE network-uuid=$NWUUID vm-uuid=$VMUUID \
       mac=$NEWMAC
    echo "Mac address has been changed from \"$OLDMAC\" to \"$NEWMAC\"."
  fi

  echo "Starting VM \"$NAME\" ..."
  xe vm-start uuid=$VMUUID
  echo "VM \"$NAME\" has been started."

done

echo Done.
