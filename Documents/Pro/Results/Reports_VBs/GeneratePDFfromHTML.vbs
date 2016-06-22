set oWSH = CreateObject("wscript.Shell")
set oEnv = oWSH.Environment("PROCESS")
oEnv("SEE_MASK_NOZONECHECKS") = 1

msgbox "Hello world!"
path = WScript.Arguments.Item(1) & “/wkhtmltopdf/bin/wkhtmltopdf.exe"
msgbox path
HTMLFile = WScript.Arguments.Item(0)
HTMLFile = Replace(HTMLFile, " ", "%20")
PDFFile = Replace(HTMLFile ,".html",".pdf")
PDFFile = Replace(PDFFile ,".html",".pdf")
PDFFile = Replace(PDFFile,”/HTMLReports/“,”/PDFReports/“)
If mid(PDFFile,1,1)="/" Then
	PDFFile  = "\\" + Mid(PDFFile,3)
End If
'msgbox PDFFile
Com = Chr(34) & path & Chr(34) & " " & Chr(34) & HTMLFile & Chr(34) & " " & Chr(34) & PDFFile & Chr(34)   
'Msgbox Com
'set oWSH = CreateObject("wscript.Shell")
oWSH.Run(Com)
Set oWSH = Nothing
oEnv.Remove("SEE_MASK_NOZONECHECKS")