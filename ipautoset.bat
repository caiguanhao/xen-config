@echo off
 echo Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
 echo Licensed under the terms of the MIT license.
 echo Report bugs on https://github.com/caiguanhao/xen-config/issues
 echo --------------------------------------------------------------

rem This is an auto script that changes the IP addresses of Windows VMs.
rem It should run once on the first-time startup.

rem This script requires xenstore_client.exe from XenTools to run.
rem Make sure you append its folder path, something like:
rem "C:\Program Files\Citrix\XenTools" to the Path environment variable.

rem Local Area Connection name
set local_conn="LocalConnection"
set local_conn=%local_conn:"=%

rem "
rem Make sure you have written IP addresses to the XenStore of each VM domain.
rem For a list of domain IDS, run `xl list` or `xenstore-list /local/domain`
rem on XenServer host.
set /a domain_id_max="100"

for /l %%i in (0,1,%domain_id_max%) do (
  for /f %%o in ('xenstore_client read /local/domain/%%i/ip') do (
    for /f "tokens=1-4 delims=." %%a in ("%%o") do (
      if not [%%d]==[] set ipaddr=%%a.%%b.%%c.%%d ))

  for /f %%o in ('xenstore_client read /local/domain/%%i/subnetmask') do (
    for /f "tokens=1-4 delims=." %%a in ("%%o") do (
      if not [%%d]==[] set subnetmask=%%a.%%b.%%c.%%d ))

  for /f %%o in ('xenstore_client read /local/domain/%%i/gateway') do (
    for /f "tokens=1-4 delims=." %%a in ("%%o") do (
      if not [%%d]==[] set gateway=%%a.%%b.%%c.%%d ))
)

rem Check if defined:
if "%ipaddr%"==""     echo Cannot get IP address         & goto theend
if "%subnetmask%"=="" echo Cannot get subnet mask        & goto theend
if "%gateway%"==""    echo Cannot get gateway IP address & goto theend

echo           IP Address: %ipaddr%
echo          Subnet Mask: %subnetmask%
echo              Gateway: %gateway%
echo.
echo Applying TCP/IP settings...

netsh interface ip set address name="%local_conn%" ^
  static %ipaddr% %subnetmask% %gateway% 1
netsh interface ip set dns     name="%local_conn%" ^
  static 8.8.8.8 >nul
netsh interface ip add dns     name="%local_conn%" ^
  8.8.4.4 index=2 >nul

:theend
timeout /t 3
