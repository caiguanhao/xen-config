If ProcessExists("tcpz.exe") Then
  Local $title = "TCP-Z   (x86)   v2.6.1.72"
  WinWait($title, "", 5)
  If WinExists($title, "") Then
    WinActivate($title, "")
  EndIf
Else
  Run("tcpz_20090406\tcpz.exe")
EndIf

$lang = WinWaitActive("Select TCP-Z UI Language", "", 1)
ControlClick($lang, "", "[CLASS:Button; INSTANCE:1]")

$error = WinWaitActive("加载驱动程序失败，错误代码: -6", "", 1)
ControlClick($error, "", "[CLASS:Button; INSTANCE:1]")

$error = WinWaitActive("加载驱动程序失败，错误代码: -6", "", 1)
ControlClick($error, "", "[CLASS:Button; INSTANCE:1]")
