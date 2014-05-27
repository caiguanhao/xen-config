; AutoIt script to automatically setup.
; --------------------------------------------------------------
; Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
; Licensed under the terms of the MIT license.
; Report bugs on https://github.com/caiguanhao/xen-config/issues
; --------------------------------------------------------------

Local $dest = "C:\Documents and Settings\Administrator\桌面"

Local $file = "C:\Documents and Settings\Administrator\桌面\guaji.zip"
Local $dl = InetGet("http://d.cgh.io/bats/guaji.zip", $file, 1, 1)
Do
  Local $info = InetGetInfo($dl)
  If $info[0] > 0 Then
    TrayTip("Downloading...", Round($info[0] / $info[1] * 100, 2) & "% completed.", 10, 1)
  EndIf
  Sleep(250)
Until InetGetInfo($dl, 2)

TrayTip("Extracting...", "Extracting program files...", 10, 1)
RunWait('"C:\Program Files\WinRAR\WinRAR.exe" x "' & $file & '" -o+ -ibck "' & $dest & '"')

FileDelete($file)

Run("C:\Documents and Settings\Administrator\桌面\5-20号挂机\挂机.exe", "C:\Documents and Settings\Administrator\桌面\5-20号挂机")

$win = WinWait("挂机")

WinMove($win, "", 0, 0)

Sleep(1000)

ControlClick($win, "", "[CLASS:WindowsForms10.BUTTON.app.0.bb8560_r15_ad1; INSTANCE:1]")

Sleep(1000)

ControlClick($win, "", "[CLASS:WindowsForms10.BUTTON.app.0.bb8560_r15_ad1; INSTANCE:1]")

Sleep(1000)

ControlClick($win, "", "[CLASS:WindowsForms10.BUTTON.app.0.bb8560_r15_ad1; INSTANCE:1]")

SelfDelete()

Func SelfDelete()
  Local $sCmdFile
  FileDelete(@TempDir & "\temp.bat")
  $sCmdFile = 'timeout /t 1 > nul' & @CRLF _
    & ':loop' & @CRLF _
    & 'del "' & @ScriptFullPath & '"' & @CRLF _
    & 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
    & 'del ' & @TempDir & '\temp.bat'
  FileWrite(@TempDir & "\temp.bat", $sCmdFile)
  Run(@TempDir & "\temp.bat", @TempDir, @SW_HIDE)
EndFunc
