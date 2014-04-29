If ProcessExists("卡淘金.exe") Then
   ProcessClose("卡淘金.exe")
   Sleep(400)
EndIf
Run("卡淘金.exe")
$ktj = WinWaitActive("[CLASS:ConsoleWindowClass]")
Send("3{ENTER}")
Sleep(600)
WinSetState($ktj, "", @SW_MINIMIZE)
