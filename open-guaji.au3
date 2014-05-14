; AutoIt script to automatically open GUAJI.
; --------------------------------------------------------------
; Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
; Licensed under the terms of the MIT license.
; Report bugs on https://github.com/caiguanhao/xen-config/issues
; --------------------------------------------------------------

Local $zip = "C:\Documents and Settings\Administrator\桌面\guaji.7z"
Local $dest = "C:\Documents and Settings\Administrator\桌面"
Local $dl = InetGet("http://d.cgh.io/guaji.7z", $zip, 1, 1)
Do
  Local $info = InetGetInfo($dl)
  If $info[0] > 0 Then
    TrayTip("Downloading...", Round($info[0] / $info[1] * 100, 2) & "% completed.", 10, 1)
  EndIf
  Sleep(250)
Until InetGetInfo($dl, 2)

TrayTip("Extracting...", "Extracting program files...", 10, 1)
RunWait('"C:\Program Files\WinRAR\WinRAR.exe" x "' & $zip & '" -o+ -ibck "' & $dest & '"')

Run($dest & "\guaji\挂机.exe")

$gj = WinWaitActive("挂机", "", 1)

ControlSetText($gj, "", "[CLASS:WindowsForms10.EDIT.app.0.2bf8098_r17_ad1; INSTANCE:4]", "")
ControlSetText($gj, "", "[CLASS:WindowsForms10.EDIT.app.0.2bf8098_r17_ad1; INSTANCE:3]", "")
ControlSetText($gj, "", "[CLASS:WindowsForms10.EDIT.app.0.2bf8098_r17_ad1; INSTANCE:2]", "")
ControlSetText($gj, "", "[CLASS:WindowsForms10.EDIT.app.0.2bf8098_r17_ad1; INSTANCE:1]", "")

ControlClick($gj, "", "[CLASS:WindowsForms10.BUTTON.app.0.2bf8098_r17_ad1; INSTANCE:1]")

TrayTip("Done.", "Everything is OK.", 10, 1)
Sleep(500)
