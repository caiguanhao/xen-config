; AutoIt script to automatically open the stats window.
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

If Not ProcessExists("AppexAcceleratorUI.exe") Then
  Run($S)
  $win = WinWaitActive($title, "", 5)
EndIf

_SysTray_ClickItem($title, "right", 1)

If @error Then
  Run($S)
  $win = WinWaitActive($title, "", 5)
  _SysTray_ClickItem($title, "right", 1)
EndIf

Sleep(100)

Send("S")
