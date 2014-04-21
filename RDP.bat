@echo off
 echo Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
 echo Licensed under the terms of the MIT license.
 echo Report bugs on https://github.com/caiguanhao/xen-config/issues
 echo --------------------------------------------------------------

rem Usage: Create or edit RDP.txt in the same directory or sub-directories
rem of this BAT file, type your IP address, username and password in order
rem and separate them by spaces or tabs. Each line represents an RDP
rem connection. For example:
rem     12.34.56.78 Administrator 123456

set /a count="0"
set k="HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\LocalDevices"

for /f "tokens=*" %%z in ('dir /s/b RDP.txt') do (
for /f "tokens=1-3" %%a in ('findstr /r "^[^#]" "%%z"') do (
for /f "tokens=1 delims=:" %%h in ("%%a") do (
for /f "tokens=*" %%d in ('RDP.exe %%c') do (
(
rem Required - User credential:
echo full address:s:%%a
echo username:s:%%b
echo password 51:b:%%d

rem You can create one RDP connection, adjust the options and then save it.
rem Open the saved file in Notepad, copy every line (except the lines contain
rem the IP address or the username) here to update settings:
echo screen mode id:i:1
echo desktopwidth:i:800
echo desktopheight:i:600
echo session bpp:i:32
echo winposstr:s:0,3,0,0,800,600
echo compression:i:1
echo keyboardhook:i:2
echo displayconnectionbar:i:1
echo disable wallpaper:i:1
echo disable full window drag:i:1
echo allow desktop composition:i:0
echo allow font smoothing:i:0
echo disable menu anims:i:1
echo disable themes:i:0
echo disable cursor setting:i:0
echo bitmapcachepersistenable:i:1
echo audiomode:i:0
echo redirectprinters:i:1
echo redirectcomports:i:0
echo redirectsmartcards:i:1
echo redirectclipboard:i:1
echo redirectposdevices:i:0
echo drivestoredirect:s:
echo autoreconnection enabled:i:1
echo authentication level:i:0
echo enablecredsspsupport:i:0
echo prompt for credentials:i:0
echo negotiate security layer:i:1
echo remoteapplicationmode:i:0
echo alternate shell:s:
echo shell working directory:s:
echo gatewayhostname:s:
) > %%z\..\%%h.rdp

rem Add host to registry to bypass the certificate warnings
reg add %k% /v %%h /f /t REG_DWORD /d 76 >nul

set /a count+=1
)
)
)
)

echo.
echo                 OK! %count% RDP connections generated.
echo              Press Enter or wait 2 seconds to exit
echo.

timeout /t 2 >nul
