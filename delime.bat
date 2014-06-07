@echo off
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\E00E0804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\E00E0804" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\E00E0804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\E00E0804" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\E00E0804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\E00E0804" /f >nul 2>nul
reg delete "HKCR\CLSID\{F3BA9074-6C7E-11D4-97FA-0080C882687E}" /va /f >nul 2>nul
reg delete "HKCR\CLSID\{F3BA9074-6C7E-11D4-97FA-0080C882687E}" /f >nul 2>nul
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MSSCIPY" /va /f >nul 2>nul
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MSSCIPY" /f >nul 2>nul
reg delete "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\MSSCIPY" /va /f >nul 2>nul
reg delete "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\MSSCIPY" /f >nul 2>nul
reg delete "HKEY_USERS\S-1-5-19\Software\Microsoft\Windows\CurrentVersion\MSSCIPY" /va /f >nul 2>nul
reg delete "HKEY_USERS\S-1-5-19\Software\Microsoft\Windows\CurrentVersion\MSSCIPY" /f >nul 2>nul
reg delete "HKEY_USERS\S-1-5-20\Software\Microsoft\Windows\CurrentVersion\MSSCIPY" /va /f >nul 2>nul
reg delete "HKEY_USERS\S-1-5-20\Software\Microsoft\Windows\CurrentVersion\MSSCIPY" /f >nul 2>nul

reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\E0010804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\E0010804" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\E0010804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\E0010804" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\E0010804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\E0010804" /f >nul 2>nul

reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\E0020804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\E0020804" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\E0020804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\E0020804" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\E0020804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\E0020804" /f >nul 2>nul

reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\E0030804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\E0030804" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\E0030804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\E0030804" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\E0030804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\E0030804" /f >nul 2>nul

reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\E0040804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\E0040804" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\E0040804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\E0040804" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\E0040804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\E0040804" /f >nul 2>nul

reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\E0050804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\E0050804" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\E0050804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\E0050804" /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\E0050804" /va /f >nul 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\E0050804" /f >nul 2>nul

msg "%username%" "已删除所有中文输入法。"
