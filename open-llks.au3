; AutoIt script to automatically open LLKS.
; --------------------------------------------------------------
; Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
; Licensed under the terms of the MIT license.
; Report bugs on https://github.com/caiguanhao/xen-config/issues
; --------------------------------------------------------------

If ProcessExists("Miner.exe") Then
  Local $ok = MsgBox(BitOR(1, 4096, 32), "关闭确认", "确定要关闭流量矿石和卡淘金？")
  If $ok = 1 Then
    ProcessClose("Miner.exe")
    ProcessClose("MinerWatch.exe")
    ProcessClose("卡淘金.exe")
  EndIf
Else
  If FileExists("C:\Program Files (x86)\Miner\Miner.exe") Then
    Run("C:\Program Files (x86)\Miner\Miner.exe")
  ElseIf FileExists("C:\Program Files\Miner\Miner.exe") Then
    Run("C:\Program Files\Miner\Miner.exe")
  Else
    MsgBox(4096, "Warning", "Miner is not installed.")
  EndIf
EndIf
