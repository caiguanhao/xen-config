; AutoIt script to automatically open KTJ.
; --------------------------------------------------------------
; Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
; Licensed under the terms of the MIT license.
; Report bugs on https://github.com/caiguanhao/xen-config/issues
; --------------------------------------------------------------

If ProcessExists("卡淘金.exe") Then
   ProcessClose("卡淘金.exe")
   Sleep(400)
EndIf
Run("卡淘金.exe")
$ktj = WinWaitActive("[CLASS:ConsoleWindowClass]")
Send("3{ENTER}")
Sleep(600)
WinSetState($ktj, "", @SW_MINIMIZE)
