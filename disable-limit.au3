; AutoIt script to automatically disable the limit option.
; --------------------------------------------------------------
; Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
; Licensed under the terms of the MIT license.
; Report bugs on https://github.com/caiguanhao/xen-config/issues
; --------------------------------------------------------------

#Include <GuiToolBar.au3>
#Include "SysTray.au3"

Local $title = "睿悠科技 锐速"
Local $S = "C:\Program Files\ServerSpeeder\AppexAcceleratorUI.exe -professional"
Local $win

If ProcessExists("AppexAcceleratorUI.exe") Then
  _SysTray_ClickItem($title, "left", 1)
  If @error Then
    Run($S)
    $win = WinWaitActive($title, "", 5)
  Else
    $win = WinWaitActive($title, "", 5)
    If WinExists($title, "") Then
      WinActivate($title, "")
    Else
      Run($S)
      $win = WinWaitActive($title, "", 5)
    EndIf
  EndIf
Else
  Run($S)
  $win = WinWaitActive($title, "", 5)
EndIf

ControlClick($win, "", "[CLASS:Button; INSTANCE:1]")

Local $settingsWin = WinWaitActive("锐速设置", "", 2);

If ControlCommand($settingsWin, "", "(&S) 启用流量整形", "IsChecked") = 1 Then
  ControlClick($settingsWin, "", "(&S) 启用流量整形")
EndIf

Sleep(400)
ControlClick($settingsWin, "", "[CLASS:Button; INSTANCE:10]")
