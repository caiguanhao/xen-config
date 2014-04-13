@echo off

echo ---------------------------------------------------------------------------
echo                             Quick IP Setter
echo               Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)

:start
echo ---------------------------------------------------------------------------

for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A

:hostipaddr
set /p hostipaddr="%BS%              XenServer Host IP: "
if [%hostipaddr%]==[] goto hostipaddr

:vmposition
set /p vmposition="%BS%      Position of this VM [1-4]: "
if [%vmposition%]==[] goto vmposition

set /p subnetmask="%BS%  Subnet mask [255.255.255.248]: "
if [%subnetmask%]==[] set subnetmask="255.255.255.248"

set /p local_conn="%BS%   Connection [LocalConnection]: "
if [%local_conn%]==[] set local_conn="LocalConnection"

set subnetmask=%subnetmask:"=%
set local_conn=%local_conn:"=%

for /f "tokens=1-4 delims=." %%a in ("%hostipaddr%") do (
  set first=%%a.%%b.%%c
  set /a minus=%%d-1
  set /a add=%%d+%vmposition%
)

echo ---------------------------------------------------------------------------
echo                         Gateway:  %first%.%minus%
echo               XenServer Host IP:  %hostipaddr%
echo                      IP address:  %first%.%add%
echo                     Subnet Mask:  %subnetmask%

echo ---------------------------------------------------------------------------
set /p OK="%BS%    [Enter to Yes, others to No]  Is this OK? "

if [%OK%]==[] netsh interface ip set address name="%local_conn%"^
  static %first%.%add% %subnetmask% %first%.%minus% 1
if [%OK%]==[] netsh interface ip set dns name="%local_conn%"^
  static 8.8.8.8 >nul
if [%OK%]==[] netsh interface ip add dns name="%local_conn%"^
  8.8.4.4 index=2 >nul

if %ERRORLEVEL% GEQ 1 goto start

if [%OK%]==[] ^
echo                          Status:  Completed! Press enter to leave.

pause >nul
