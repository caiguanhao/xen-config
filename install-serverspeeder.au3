; AutoIt script to automatically install ServerSpeeder, the Chi-
; nese version.
; --------------------------------------------------------------
; Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
; Licensed under the terms of the MIT license.
; Report bugs on https://github.com/caiguanhao/xen-config/issues
; --------------------------------------------------------------

#include <Constants.au3>

Local $title = "一键安装锐速"
Local $username = "user@example.com"
Local $password = "password"

Local $answer = MsgBox(BitOR($MB_OKCANCEL, $MB_SYSTEMMODAL, $MB_ICONQUESTION), _
  $title, "即将一键安装锐速中文版。若已安装，则将自动卸载。另外，你需要将 " & _
  "serverSpeeder.1.6.2.0.exe 放置于本程序目录下。" & @LF & _
  "Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)" & @LF & @LF & _
  "安装账号： " & $username)

If $answer = 2 Then
  Exit
EndIf

If FileExists("C:\Program Files\ServerSpeeder\unins000.exe") = 1 Then
  Run("C:\Program Files\ServerSpeeder\unins000.exe")
  Local $confirmWin = WinWaitActive("[CLASS:#32770]", "", 15)
  ControlClick($confirmWin, "", "[CLASS:Button; INSTANCE:1]")
  Local $confirmWin = WinWaitActive("[CLASS:#32770]", "&N", 15)
  ControlClick($confirmWin, "", "[CLASS:Button; INSTANCE:2]")
EndIf

Run("serverSpeeder.1.6.2.0.exe")

Local $langWin = WinWaitActive("[CLASS:TSelectLanguageForm]")

ControlCommand($langWin, "", "[CLASS:TNewComboBox; INSTANCE:1]", _
  "SetCurrentSelection", 1)
ControlClick($langWin, "", "[CLASS:TNewButton; INSTANCE:1]")

Local $wizardWin = WinWaitActive("[CLASS:TWizardForm]")
ControlClick($wizardWin, "", "[CLASS:TNewButton; INSTANCE:1]")

Local $wizardWin = WinWaitActive("[CLASS:TWizardForm]")
ControlCommand($wizardWin, "", "[CLASS:TNewRadioButton; INSTANCE:1]", "Check")
ControlClick($wizardWin, "", "[CLASS:TNewButton; INSTANCE:2]")

Local $wizardWin = WinWaitActive("[CLASS:TWizardForm]")
ControlSetText($wizardWin, "", "[CLASS:TEdit; INSTANCE:2]", $username)
ControlSetText($wizardWin, "", "[CLASS:TEdit; INSTANCE:1]", $password)
ControlClick($wizardWin, "", "[CLASS:TNewButton; INSTANCE:2]")

Local $infoWin = WinWaitActive("Info", "", 20)
ControlClick($infoWin, "", "[CLASS:Button; INSTANCE:1]")

Local $wizardWin = WinWaitActive("[CLASS:TWizardForm]", "锐速安装向导完成")
ControlCommand($wizardWin, "", "[CLASS:TNewRadioButton; INSTANCE:2]", "Check")
ControlClick($wizardWin, "", "[CLASS:TNewButton; INSTANCE:2]")

Local $answer = MsgBox(BitOR($MB_YESNO, $MB_SYSTEMMODAL, $MB_ICONQUESTION), _
  $title, "安装已完成！因为安装文件包含密码，建议删除此安装文件。按“是”删除此一键安装程序。")

If $answer = 6 Then
  SelfDelete()
EndIf

Func SelfDelete()
  Local $sCmdFile
  FileDelete(@TempDir & "\temp.bat")
  $sCmdFile = 'timeout /t 1 > nul' & @CRLF _
    & ':loop' & @CRLF _
    & 'del "' & @ScriptFullPath & '"' & @CRLF _
    & 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
    & 'del "C:\Documents and Settings\Administrator\桌面\一键安装锐速.lnk"' _
    & @CRLF & 'del ' & @TempDir & '\temp.bat'
  FileWrite(@TempDir & "\temp.bat", $sCmdFile)
  Run(@TempDir & "\temp.bat", @TempDir, @SW_HIDE)
EndFunc
