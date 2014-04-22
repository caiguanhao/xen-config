rem Copy following content directly to Command Prompt and it will download
rem binary file to your location. If your location is in C:, make sure
rem you have Administrator privileges to run the command.

(echo|set /p="strFileURL = "http://d.cgh.io/FileTransfer.exe""
echo.
echo|set /p="strHDLocation = "C:\FileTransfer.exe""
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
cscript.exe "C:\tmp.download.vbs"
del "C:\tmp.download.vbs"
exit
