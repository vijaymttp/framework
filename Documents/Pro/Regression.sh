
cd /Users/IT-Satya/Desktop/workspace


echo $Automation_Path
echo $TMPDIR
echo $Project_Name
echo $TESTNG_HOME
echo issssssssssssss
echo $JobName
echo $IPAddress
echo $TestCases
echo $BUILD_NUMBER
export JobName=$JobName
export Build=$BUILD_NUMBER
export testCases=$TestCases

java -cp /Users/IT-Satya/Desktop/workspace/FinalJars/*:/Users/IT-Satya/Desktop/workspace/RouthuJars/*:/Users/IT-Satya/Desktop/workspace/$Project_Name/bin:.: org.testng.TestNG /Users/IT-Satya/Desktop/workspace/JDSportsScottsAndroidNativeApp/dynamicXml.xml
java -cp /Users/IT-Satya/Desktop/workspace/FinalJars/*:/Users/IT-Satya/Desktop/workspace/RouthuJars/*:/Users/IT-Satya/Desktop/workspace/$Project_Name/bin:.: org.testng.TestNG -d   $TMPDIR/test-output/  $TestNG_SuiteFilePath

cd $Automation_Path$Project_Name/ANT/1.9.5/bin 
ant -Dxmlfile=$TestNG_SuiteFilePath makeXsltReports ZIP -DEmailTo="$EmailTo"
