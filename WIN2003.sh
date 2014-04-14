#!/bin/bash

set -e

copyright() {
  echo "Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)"
  echo "Licensed under the terms of the MIT license."
  echo "Report bugs on https://github.com/caiguanhao/xen-config/issues"
  echo
}

help() {
  echo "Usage: bash $0 [options]"
  echo "  -h, --help                Show this help and exit"
  echo
  echo "  -u, --url      <url>      URL of the template to download"
  echo "                            default is $NODE_P$NODE_S<template-name>.7z"
  echo "                            If it is a number like '2', it will be:"
  echo "                            ${NODE_P}2$NODE_S<template-name>.7z"
  echo "  -p, --password <password> Use this password when extracting .7z"
  echo "  -t, --template <name>     Template name, default: $TEMPLATE"
  echo "  -l, --disk     <name>     Disk name, default: $DISKNAME"
  echo "  -d, --disksize <size>     User disk size, default: $DISKSIZE"
  echo "  -m, --memory   <size>     Memory size, default: $MEMORY"
  echo
  echo "  -n, --number   <number>   Number of VMs to create, default: $VMNUMBER"
  echo "  -1, -2, ..., -10, ...     Only process nth VMs. --number is ignored."
  echo "  -s, --no-namesake         Delete VMs having the same name if exists"
  echo
  echo "  -y, --no-confirm          Don't waste time to confirm"
  echo "      --skip-host-label     Don't you ever touch my host name label!"
  echo "      --skip-tpl-download   Don't download template again"
  echo "      --skip-tpl-import     Don't import template again"
  echo "      --skip-tpl-adjust     Don't adjust memory and disk"
  echo "      --skip-vm-install     I have my virtual machines installed!"
  echo
  echo "  -#, --progress-bar        I just love to use cURL's progress bar"
  exit 0
}

unknown() {
  echo "Error: Unknown option -- $@."
  echo "Use bash $0 -h for more help info."
  exit 1
}

# Variables:
NODE_P="http://d"
NODE_S=".cgh.io/"
TEMPLATE=WIN2003
DISKNAME=DTP_Windows_2003_c
DISKSIZE=100GiB
MEMORY=3GiB
VMNUMBER=4
P7ZIPPASS=
INSTALLVMS=()
LVNAME=CGH
CURLPBAR=

# Switches:
SKIPHOSTLABEL=No
SKIPTPLDWLOAD=No
SKIPTPLIMPORT=No
SKIPTPLADJUST=No
SKIPVMINSTALL=No
NOCONFIRM=No
NONAMESAKE=No

copyright

for argument in "$@"; do
  case "$argument" in
  -h|--help)                    help                         ;;
  -u|--url)              shift; OSURL="$1";            shift ;;
  -p|--password)         shift; P7ZIPPASS="-p$1";      shift ;;
  -t|--template)         shift; TEMPLATE="$1";         shift ;;
  -l|--disk)             shift; DISKNAME="$1";         shift ;;
  -d|--disksize)         shift; DISKSIZE="$1";         shift ;;
  -m|--memory)           shift; MEMORY="$1";           shift ;;
  -n|--number)           shift; VMNUMBER="$1";         shift ;;
  -s|--no-namesake)      shift; NONAMESAKE=Yes               ;;
  -y|--no-confirm)       shift; NOCONFIRM=Yes                ;;
     --skip-host-label)  shift; SKIPHOSTLABEL=Yes            ;;
     --skip-tpl-download)shift; SKIPTPLDWLOAD=Yes            ;;
     --skip-tpl-import)  shift; SKIPTPLIMPORT=Yes            ;;
     --skip-tpl-adjust)  shift; SKIPTPLADJUST=Yes            ;;
     --skip-vm-install)  shift; SKIPVMINSTALL=Yes            ;;
  -#|--progress-bar)     shift; CURLPBAR="-#"                ;;
  -*[!0-9]*)                    unknown $argument            ;;
  -*)                           INSTALLVMS+=(${1/-/}); shift ;;
  esac
done

case $OSURL in
  "")            OSURL="$NODE_P$NODE_S$TEMPLATE.7z"          ;;
  *[!0-9]*)                                                  ;;
  *)             OSURL="$NODE_P$OSURL$NODE_S$TEMPLATE.7z"    ;;
esac

if [[ $NOCONFIRM == "No" ]]; then
  echo Options enabled:
  if [[ $SKIPTPLDWLOAD == "No" ]]; then
    echo "  -u" .. URL of template to download ............. $OSURL
  fi
    echo "  -t" .. Template name ........................... $TEMPLATE
    echo "  -l" .. Change disk of this name ................ $DISKNAME
    echo "  -d" .. Change user disk size to ................ $DISKSIZE
    echo "  -m" .. Change memory size of template to ....... $MEMORY
  if [[ ${#INSTALLVMS[@]} -eq 0 ]]; then
    echo "  -n" .. Number of VMs to create ................. $VMNUMBER
  else
    echo "  --" .. Nth VMs to create ....................... ${INSTALLVMS[@]}
  fi
  echo   "  -s" .. Delete VMs having the same name ......... $NONAMESAKE
  echo   "    " .. Skip host label update .................. $SKIPHOSTLABEL
  echo   "    " .. Skip template download .................. $SKIPTPLDWLOAD
  echo   "    " .. Skip template import .................... $SKIPTPLIMPORT
  echo   "    " .. Skip template adjustment ................ $SKIPTPLADJUST
  echo   "    " .. Skip VM installation .................... $SKIPVMINSTALL
  echo
  echo   "Operation starts in 10 seconds... Press Ctrl-C to Cancel"
  for s in `seq 10 1`; do
    printf "$s.."
    sleep 1
  done
  echo 0
fi


# Getting basic information ####################################################
IFS=$' \t\n'
HOSTUUID=(`xe host-list | grep ^uuid | sed 's/.*: //'`)
if [[ ${#HOSTUUID[@]} -gt 1 ]]; then
  echo "Error: it should have one host. Right?"
  exit 1
fi
IPADDR=`xe host-param-get uuid=$HOSTUUID param-name=address`
if [[ $IPADDR == "" ]]; then
  echo Getting IP address from ifconfig instead of xe command...
  IPADDR=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | \
          grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
fi
IFS=$','
for PIFUUID in `xe pif-list --minimal`; do
  PIFIP=`xe pif-param-get param-name=IP uuid=$PIFUUID`
  if [[ $PIFIP == $IPADDR ]]; then
    SUBNETMASK=`xe pif-param-get param-name=netmask uuid=$PIFUUID`
    GATEWAY=`xe pif-param-get param-name=gateway uuid=$PIFUUID`
  fi
done
if [[ $SUBNETMASK == "" || $GATEWAY == "" ]]; then
  echo Failed to get subnet mask and gateway IP address.
  exit 1
fi
# Finshed getting basic information ############################################


# Start updating the name label of Xen host ####################################
if [[ $SKIPHOSTLABEL == "No" ]]; then
  echo Updating name of Xen host...
  OLDNAME=`xe host-param-get uuid=$HOSTUUID param-name=name-label`
  NEWNAME="$IPADDR"
  if [[ $NEWNAME == $OLDNAME ]]; then
    echo No need to change the name of Xen host: \"$OLDNAME\"
  else
    xe host-param-set uuid=$HOSTUUID name-label=$NEWNAME
    echo Name of Xen host has been changed from \"$OLDNAME\" to \"$NEWNAME\"...
  fi
fi
# Finished updating the name label of Xen host #################################


# Start downloading and adjusting template #####################################
if [[ $SKIPTPLDWLOAD == "No" ]]; then
  if [[ ! -d /$LVNAME ]]; then
    echo Creating Storage...
    VGNAME=`vgs | grep "VG_XenStorage" | cut -c 3-52`
    lvcreate -L 35GB -n $LVNAME $VGNAME
    mkfs.ext3 /dev/$VGNAME/$LVNAME
    mkdir /$LVNAME
    mount /dev/$VGNAME/$LVNAME /$LVNAME
  fi

  cd /$LVNAME

  echo Downloading template...
  curl -LOC - $CURLPBAR $OSURL

  if [[ ! -f ./7z/7z ]]; then
    echo Downloading p7zip...
    P7ZIPURL="http://sourceforge.net/projects/p7zip/files/p7zip/9.20.1/"
    P7ZIPURL="${P7ZIPURL}p7zip_9.20.1_x86_linux_bin.tar.bz2/download"
    curl -sL $P7ZIPURL | tar jfx - &&\
    mv p7zip_9.20.1/bin 7z && rm -rf p7zip_9.20.1
  fi

  echo Extracting archive...
  ./7z/7z x $TEMPLATE.7z -y $P7ZIPPASS
fi

if [[ $SKIPTPLIMPORT == "No" ]]; then
  echo Importing Template...
  xe vm-import filename=$TEMPLATE.xva
  echo Template is imported.
fi

if [[ $SKIPTPLADJUST == "No" ]]; then
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
fi
# Finished downloading and adjusting template ##################################


# Start creating VMs ###########################################################
if [[ $SKIPVMINSTALL == "No" ]]; then
  if [[ ${#INSTALLVMS[@]} -eq 0 ]]; then
    echo Creating $VMNUMBER virtual machine\(s\) from template...
    SEQUENCE=`seq $VMNUMBER`
  else
    echo Creating ${#INSTALLVMS[@]} virtual machine\(s\) from template...
    SEQUENCE="${INSTALLVMS[@]}"
  fi

  IPADDR1=${IPADDR%.*}
  IPADDR2=${IPADDR##*.}

  for i in $SEQUENCE; do
    VMIPADDR="$IPADDR1.$(($IPADDR2 + $i))"
    NAME=$VMIPADDR

    if [[ $NONAMESAKE == "Yes" ]]; then
      IFS=$' \t\n'
      NAMESAKES=(`xe vm-list | grep "$NAME" -B 1 | grep ^uuid | sed 's/.*: //'`)
      if [[ ${#NAMESAKES[@]} -eq 0 ]]; then
        echo "Don't worry. No VM uses the name $NAME."
      else
        for NS in "${NAMESAKES[@]}"; do
          xe vm-uninstall uuid=$NS force=true
        done
      fi
    fi

    echo Creating new VM named $NAME from template $TEMPLATE...
    VMUUID=`xe vm-install new-name-label=$NAME template=$TEMPLATE`
    echo "VM $NAME created."

    echo "Modifying MAC address for VM $NAME..."
    VIFUUID=(`xe vif-list vm-uuid=$VMUUID | grep ^uuid | sed 's/.*: //'`)

    if [[ ${#VIFUUID[@]} -gt 1 ]]; then
      echo "Error: more than one vif is found for VM named $NAME."
      exit 1
    fi
    if [[ ${#VIFUUID[@]} -lt 1 ]]; then
      echo "Error: no vif is found for VM named $NAME."
      exit 1
    fi

    OLDMAC=`xe vif-param-get uuid=$VIFUUID param-name=MAC`
    NEWMAC="${OLDMAC:0:1}6${OLDMAC:2}"
    if [[ $NEWMAC == $OLDMAC ]]; then
      echo "No need to change Mac address: $OLDMAC"
    else
      DEVICE=`xe vif-param-get uuid=$VIFUUID param-name=device`
      NWUUID=`xe vif-param-get uuid=$VIFUUID param-name=network-uuid`
      xe vif-destroy uuid=$VIFUUID
      xe vif-create device=$DEVICE network-uuid=$NWUUID vm-uuid=$VMUUID \
         mac=$NEWMAC
      echo "Mac address has been changed from $OLDMAC to $NEWMAC."
    fi

    echo "Starting VM $NAME ..."
    xe vm-start uuid=$VMUUID
    echo "VM $NAME has been started."

    # Get Domain ID after VM starts
    VMDOMID=`xe vm-param-get uuid=$VMUUID param-name=dom-id`
    xenstore-write /local/domain/$VMDOMID/ip         $VMIPADDR
    xenstore-write /local/domain/$VMDOMID/subnetmask $SUBNETMASK
    xenstore-write /local/domain/$VMDOMID/gateway    $GATEWAY
    echo "IP address has been written to XenStore with Domain ID $VMDOMID..."
    echo "          IP Address: $VMIPADDR"
    echo "         Subnet Mask: $SUBNETMASK"
    echo "             Gateway: $GATEWAY"
    echo
  done
fi
# Finished creating VMs ########################################################


echo Done.
exit 0
