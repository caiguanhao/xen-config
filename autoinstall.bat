@echo off
rem This is a script to automatically re-install Miner.
rem Remember to change the line feed if you don't want to see the weird errors:
rem vim autoinstall.bat && perl -pi -e 's/\n/\r\n/' autoinstall.bat
echo Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
echo Licensed under the terms of the MIT license.
echo Report bugs on https://github.com/caiguanhao/xen-config/issues
echo --------------------------------------------------------------
echo Killing Miner... 2>nul
taskkill /f /t /im Miner.exe >nul 2>nul
taskkill /f /t /im MinerWatch.exe >nul 2>nul
taskkill /f /t /im 卡淘金.exe >nul 2>nul
echo Miner killed.
echo Uninstalling...
"%ProgramFiles%\Miner\uninst.exe" /S 2>nul
echo Uninstalled.
echo Cleaning up...
RD /S /Q "%ALLUSERSPROFILE%\Application Data\Miner\Data" 2>nul
del "%ALLUSERSPROFILE%\Application Data\Miner\TaskCfg.dbx" 2>nul
RD /S /Q "D:\MinerCache" 2>nul
del "%ALLUSERSPROFILE%\Application Data\Miner\*.txt" 2>nul
echo Cleaned up.
echo Downloading MinerSetup_1.0.109.72.exe...
(echo|set /p="strFileURL = "http://d.cgh.io/MinerSetup_1.0.109.72.exe""
echo.
echo|set /p="strHDLocation = "D:\MinerSetup_1.0.109.72.exe""
echo.
echo|set /p="Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")"
echo.
echo|set /p="objXMLHTTP.open "GET", strFileURL, false"
echo.
echo|set /p="objXMLHTTP.send()"
echo.
echo|set /p="If objXMLHTTP.Status = 200 Then"
echo.
echo|set /p="Set objADOStream = CreateObject("ADODB.Stream")"
echo.
echo|set /p="objADOStream.Open"
echo.
echo|set /p="objADOStream.Type = 1"
echo.
echo|set /p="objADOStream.Write objXMLHTTP.ResponseBody"
echo.
echo|set /p="objADOStream.Position = 0"
echo.
echo|set /p="Set objFSO = Createobject("Scripting.FileSystemObject")"
echo.
echo|set /p="If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation"
echo.
echo|set /p="Set objFSO = Nothing"
echo.
echo|set /p="objADOStream.SaveToFile strHDLocation"
echo.
echo|set /p="objADOStream.Close"
echo.
echo|set /p="Set objADOStream = Nothing"
echo.
echo|set /p="End if"
echo.
echo|set /p="Set objXMLHTTP = Nothing") > "C:\tmp.download.vbs"
cscript.exe "C:\tmp.download.vbs" >nul 2>nul
del "C:\tmp.download.vbs" 2>nul
echo Downloaded.
echo Wait 3 seconds...
timeout /t 3 >nul
echo Installing Miner...
"D:\MinerSetup_1.0.109.72.exe" /S 2>nul
echo Installed.
echo Downloading TaskCfg.dbx...
(echo|set /p="strFileURL = "http://d.cgh.io/TaskCfg.dbx""
echo.
echo|set /p="strHDLocation = "%ALLUSERSPROFILE%\Application Data\Miner\TaskCfg.dbx""
echo.
echo|set /p="Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")"
echo.
echo|set /p="objXMLHTTP.open "GET", strFileURL, false"
echo.
echo|set /p="objXMLHTTP.send()"
echo.
echo|set /p="If objXMLHTTP.Status = 200 Then"
echo.
echo|set /p="Set objADOStream = CreateObject("ADODB.Stream")"
echo.
echo|set /p="objADOStream.Open"
echo.
echo|set /p="objADOStream.Type = 1"
echo.
echo|set /p="objADOStream.Write objXMLHTTP.ResponseBody"
echo.
echo|set /p="objADOStream.Position = 0"
echo.
echo|set /p="Set objFSO = Createobject("Scripting.FileSystemObject")"
echo.
echo|set /p="If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation"
echo.
echo|set /p="Set objFSO = Nothing"
echo.
echo|set /p="objADOStream.SaveToFile strHDLocation"
echo.
echo|set /p="objADOStream.Close"
echo.
echo|set /p="Set objADOStream = Nothing"
echo.
echo|set /p="End if"
echo.
echo|set /p="Set objXMLHTTP = Nothing") > "C:\tmp.download.vbs"
mkdir "%ALLUSERSPROFILE%\Application Data\Miner" 2>nul
cscript.exe "C:\tmp.download.vbs" >nul 2>nul
del "C:\tmp.download.vbs" 2>nul
explorer.exe "%ALLUSERSPROFILE%\Application Data\Miner" 2>nul
echo Downloaded.
echo Writing Configs...
(echo|set /p="<?xml version="1.0" encoding="utf-8"?>"
echo.
echo|set /p="<Miner version="1.0.0.0"><LastLoginUser Value=""/><SharePath Value="D:\MinerCache\"/><DiscSize Value="0"/><AutoRun Value="1"/><MinWnd Value="0"/><TopMost Value="0"/><WndAlpha Value="0"/><ExitPopUp Value="0"/><AutoLogin Value="1"/><RembPaword Value="1"/><BossSet Value="1"/><BossCtrl Value="1"/><BossKey Value="71"/><SoudNotice Value="1"/><DownloadSpeed Value="0"/><UploadSpeed Value="0"/><PosX Value="-1"/><PosY Value="-1"/><BossSetCheckPsw Value="0"/><MultiDisk Value="0"/><NewYearSkin Value="0"/><UserGuaidCount Value="2"/><UserHelpTipsVersion Value="1"/></Miner>"
echo.
) > "%ALLUSERSPROFILE%\Application Data\Miner\Miner.xml"
reg copy "HKCU\Control Panel\International" "HKCU\Control Panel\International-Temp" /f >nul
reg add "HKCU\Control Panel\International" /v sShortDate /d "yyyy-MM-dd" /f >nul
set today=%date%
reg copy "HKCU\Control Panel\International-Temp" "HKCU\Control Panel\International" /f >nul
reg delete "HKCU\Control Panel\International-Temp" /f >nul
for /f "tokens=1-3 delims=/:." %%a in ("%time%") do (
  set HH=%%a
  set MM=%%b
  set SS=%%c
)
echo 上次一键重装时间为 %today% %HH%:%MM%:%SS% > "%ALLUSERSPROFILE%\Application Data\Miner\%today% %HH%-%MM%-%SS%.txt"
echo %today% is OK.
echo Config written.
echo Done. Exit in 3 seconds...
timeout /t 3 >nul
