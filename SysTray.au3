; http://www.autoitscript.com/forum/topic/63397-mouse-click-on-item-in-windows-system-tray/#entry472987

Func _SysTray_ClickItem($iTitle, $iButton = "left", $iClick = 1, $sMove = False, $iSpeed = 1)
  Local $hToolbar, $iButCount, $aRect, $hButton, $cID, $i

  $hToolbar = ControlGetHandle("[Class:Shell_TrayWnd]", "", "[Class:ToolbarWindow32;Instance:1]")
  If @error Then
    Return SetError(1, 0, 0)
  EndIf

  $iButCount = _GUICtrlToolbar_ButtonCount($hToolbar)
  If $iButCount = 0 Then
    Return SetError(1, 0, 0)
  EndIf

  $hButton = ControlGetHandle("[Class:Shell_TrayWnd]", "", "Button2")
  If $hButton <> "" Then ControlClick("[Class:Shell_TrayWnd]", "", "Button2")

  For $i = 0 To $iButCount - 1
    $cID = _GUICtrlToolbar_IndexToCommand($hToolBar, $i)
    If StringInStr(_GUICtrlToolbar_GetButtonText($hToolBar, $cID), $iTitle) Then
      _GUICtrlToolbar_ClickButton($hToolbar, $cID, $iButton, $sMove, $iClick, $iSpeed)
      Return 1
    EndIf
  Next
  Return SetError(1, 0, 0)
EndFunc
