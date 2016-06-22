    path = "C:\Program Files (x86)\wkhtmltopdf\bin\wkhtmltopdf.exe"
    'HTMLFile = InputBox("Enter your HTML File Path.")

	HTMLFile ="C:/TestAutomation/Results/Tesla/HTMLReports/TaxValidation_180614124827.html"
	HTMLFileNormalized = Replace(HTMLFile, "\\", "/")
    'HTMLFileNormalized = ReplaceHTMLFileNormalized "\", "/")
    HTMLFileNormalized = ReplaceHTMLFileNormalized " ", "%20")
	PDFFile = Replace(HTMLFileNormalized ,"\HTMLReports\","\PDFReports\")
    PDFFile = Replace(PDFFile ,".html",".pdf")
msgbox PDFFile 
    Com = Chr(34) & path & Chr(34) & " " & Chr(34) & HTMLFile & Chr(34) & " " & Chr(34) & PDFFile & Chr(34)   
	set oWSH = CreateObject("wscript.Shell")
	oWSH.Run(Com)
	Set oWSH = Nothing