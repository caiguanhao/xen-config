; AutoIt script to automatically set the upload limit to 20000.
; --------------------------------------------------------------
; Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
; Licensed under the terms of the MIT license.
; Report bugs on https://github.com/caiguanhao/xen-config/issues
; --------------------------------------------------------------

#include <Constants.au3>

Run("C:\Program Files\ServerSpeeder\AppexAcceleratorUI.exe -professional")

Local $win = WinWaitActive("睿悠科技 锐速", "", 5)

ControlClick($win, "", "[CLASS:Button; INSTANCE:1]")

Local $settingsWin = WinWaitActive("锐速设置", "", 2);

If ControlCommand($settingsWin, "", "(&S) 启用流量整形", "IsChecked") = 0 Then
  ControlClick($settingsWin, "", "(&S) 启用流量整形")
EndIf

ControlSetText($settingsWin, "", "[CLASS:Edit; INSTANCE:1]", "20000")
Sleep(400)
ControlClick($settingsWin, "", "[CLASS:Button; INSTANCE:10]")