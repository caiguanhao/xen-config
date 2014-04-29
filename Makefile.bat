
@echo off

rem Makefile to compile AutoIt scripts to EXE files.
rem You may see errors if you are not using Windows 7 or newer system.
rem Simply remove any Unicode and the chcp command if you want to use
rem this script on legacy Windows systems.
rem This scirpt needs Aut2exe.exe and Ahk2Exe.exe. You may need to
rem change their paths.
rem It is recommended you use 7zip to compress the output files.

echo Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
echo Licensed under the terms of the MIT license.
echo Report bugs on https://github.com/caiguanhao/xen-config/issues
echo --------------------------------------------------------------

chcp 65001 >nul 2>nul

mkdir dist >nul 2>nul

echo Compiling disable-limit.exe...
"C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe" ^
  /in disable-limit.au3 ^
  /out "dist\一键无整形.exe" ^
  /icon cghio.ico ^
  /x86 /comp 4 /pack ^
  /companyname cgh.io ^
  /filedescription "一键无整形 One click to disable speed limit." ^
  /legalcopyright "Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)"

echo Compiling limit-20000.exe...
"C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe" ^
  /in limit-20000.au3 ^
  /out "dist\一键20000.exe" ^
  /icon cghio.ico ^
  /x86 /comp 4 /pack ^
  /companyname cgh.io ^
  /filedescription "一键20000 One click to set limit to 20000." ^
  /legalcopyright "Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)"

echo Compiling limit-26000.exe...
"C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe" ^
  /in limit-26000.au3 ^
  /out "dist\一键26000.exe" ^
  /icon cghio.ico ^
  /x86 /comp 4 /pack ^
  /companyname cgh.io ^
  /filedescription "一键26000 One click to set limit to 26000." ^
  /legalcopyright "Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)"

echo Compiling install-serverspeeder.exe...
"C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe" ^
  /in install-serverspeeder.au3 ^
  /out "dist\一键安装锐速.exe" ^
  /icon cghio.ico ^
  /x86 /comp 4 /pack ^
  /companyname cgh.io ^
  /filedescription "一键安装锐速 One click to install ServerSpeeder." ^
  /legalcopyright "Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)"

echo Compiling hotkey...
"Ahk2Exe.exe" ^
  /in hotkey.ahk ^
  /out "dist\启动快捷键监听.exe" ^
  /icon cghio.ico

echo Done. Press Enter to exit.

pause >nul
