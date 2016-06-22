XMLFileName = WScript.Arguments.Item(0)
ResultFileLocation = WScript.Arguments.Item(1)
'XMLFileName = "TC_97_3_1_1.xml"
'ResultFileLocation = "\\10.33.73.85\TestAutomation\Results\Tesla\HTMLReports"
'Create shell object
Set WShell=CreateObject("WScript.Shell")

'Create the FSO object to copy the file
set fso = CreateObject("Scripting.filesystemobject")
WScript.Sleep 6000 'Wait for Selenium xml file to finalize
'Copying the Custom Result file from the XML results\temp folder to the Effecta pickup location
msgbox "W:\Results\Tesla\CustomeReports\"&XMLFileName
msgbox ResultFileLocation & "\" & XMLFileName
fso.copyfile "W:\Results\Tesla\CustomeReports\"&XMLFileName,ResultFileLocation & "\" & XMLFileName,True
WScript.Sleep 6000  'Wait for the file complete file copying