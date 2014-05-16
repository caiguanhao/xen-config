; AutoIt script to get upload speed text from LLKS and write it
; to XenStore.
; --------------------------------------------------------------
; Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
; Licensed under the terms of the MIT license.
; Report bugs on https://github.com/caiguanhao/xen-config/issues
; --------------------------------------------------------------

#include <File.au3>

Local $c2t = "C:\Documents and Settings\Administrator\桌面\全套\Capture2Text"
Local $dest = $c2t
Local $file = "C:\Documents and Settings\Administrator\桌面\全套\Capture2Text.zip"
Local $dl = InetGet("http://d.cgh.io/Capture2Text.zip", $file, 1, 1)
If Not FileExists($dest) Then
  DirCreate($dest)
  Do
    Local $info = InetGetInfo($dl)
    If $info[0] > 0 Then
      TrayTip("Downloading...", Round($info[0] / $info[1] * 100, 2) & "% completed.", 10, 1)
    EndIf
    Sleep(250)
  Until InetGetInfo($dl, 2)
  TrayTip("Extracting...", "Extracting program files...", 10, 1)
  RunWait('"C:\Program Files\WinRAR\WinRAR.exe" x "' & $file & '" -o+ -ibck "' & $dest & '"')
EndIf

Local $exist
Local $activated = 0
Local $win
Local $wait = 5000

While 1
  $exist = WinExists("流量矿石系统")
  If $exist Then
    If $activated == 0 Then
      $win = WinActivate("流量矿石系统")
      $activated = 1
    EndIf
  Else
    $activated = 0
    Sleep($wait)
    ContinueLoop
  EndIf
  Local $pos = WinGetPos($win)
  Local $offset_x = 53
  Local $offset_y = 7
  Local $coord = $pos[0] + $offset_x & " " & $pos[1] + $offset_y & " " & _
  $pos[0] + $offset_x + 57 & " " & $pos[1] + $offset_y + 17
  Local $temp = _TempFile()
  RunWait('"' & $c2t & '\Capture2Text.exe" ' & $coord & ' "' & $temp & '"')
  Local $line = FileReadLine($temp)
  FileDelete($temp)
  RunWait('"C:\Program Files\Citrix\XenTools\xenstore_client.exe" write llks "' & $line & '"')
  ;TrayTip($line, $temp, 10, 1)
  Sleep($wait)
Wend
