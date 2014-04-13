XEN-CONFIG
==========

Tools I used to accelerate the installation of Xen virtual machines.

Requires: XenServer 6

Origin
------

Originally, I use this script to install virtual machines. You can choose
Windows or Linux systems from the shell script. The auto script contains
many configurations that some administrators might not actually need.
The download speed sometimes is slow, probably many people are using this
method since they are new to the system or don't know how to their own scripts.

```shell
cd /tmp
rm -rf Auto.sh
wget http://os.xensystem.net/XenSystem/download/Auto.sh
sh Auto.sh
```

The system is fine, you can build your own template based on this script.

How-tos
-------

### Make a template

Once you complete creating a new virtual machine from one of the templates
above, log in to the system and do what you want. One thing to keep in mind
is that you should not alter the disk size or memory settings. For me, I
failed many times exporting templates that has total disk space more than
10 GB. And you should not install any software that may validate the uniqueness
of the system -- they are probably not working on virtual machines that come
from one template.

Once you completes your configurations, take a snapshot of your virtual
machine (with disk only). And then save the snapshot as a template. And copy
the uuid of the template. These tasks are OK to do in XenCenter.

### Export a template

Then you are probably need to enter commands in the host via SSH. But if your
connection is lost, your current job will break. And since XenServer doesn't
contain `screen` and you probably don't want to install one there, it is
recommended you connect to the host via SSH from `screen` in Ubuntu and other
Linux distros. Alternatively, you can use `mosh` to keep connectivity and
accelerate typing.

Once you logged in, you will need a directory bigger enough to place your
template. This script will create a /CGH directory with 35GB free space:

```shell
LVNAME=CGH
VGNAME=`vgs | grep "VG_XenStorage" | cut -c 3-53 | tr -d ' '`
lvcreate -L 35GB -n $LVNAME $VGNAME
mkfs.ext3 /dev/$VGNAME/$LVNAME
mkdir /$LVNAME
mount /dev/$VGNAME/$LVNAME /$LVNAME
```

Then change to /CGH directory and export the template there:

```shell
xe template-export template-uuid=<uuid> filename=MyOS.xva
```

The task is a little time-consuming, you can open another `screen` by pressing
CTRL-A then C, change to the same directory and watch the file size:

```shell
watch -n 1 ls -l --block-size=M MyOS.xva
```

### Copy the template to other virtual machines

Don't use `nfs` or `ftp`. `scp` is just enough. Before you copy the template,
it is better to compress it. You can use `p7zip`. If you are a lazy person,
download the p7zip binary:

```shell
curl -sL "http://sourceforge.net/projects/p7zip/files/p7zip/9.20.1/"\
"p7zip_9.20.1_x86_linux_bin.tar.bz2/download" | tar jvfx - &&\
mv p7zip_9.20.1/bin 7z && rm -rf p7zip_9.20.1
```

Then make a archive. An archive file of 7GB template file takes up to 15
minutes to complete archiving and ends up to be a 2.9GB 7z file.

```shell
./7z/7z a -p MyOS-encrypted.7z MyOS.xva
```

Use `scp` to copy the 7z file to other host or other XenServer. Make sure the
other host has sufficient space to process the template file.

```shell
scp MyOS-encrypted.7z root@111.111.111.111:/CGH
```

Then it's time to extract the archive file. Extracting a 2.9GB 7z file needs
about 5 minutes.

```shell
./7z/7z x MyOS-encrypted.7z
```

### Import the template

Importing the template to XenServer is easy, but is also a time-consuming task.

```shell
xe vm-import filename=MyOS.xva
```

### Faster login

Add these lines to `ssh_config` file to avoid answering `yes` when connecting
to server via SSH.

```
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
```

And you can use `sshpass` to enter the password in a oneliner. You should ONLY
use this command on your personal computer.

```shell
sshpass -p "password" ssh root@host 'curl -sL http://host/WIN2003.sh | sh'
```
