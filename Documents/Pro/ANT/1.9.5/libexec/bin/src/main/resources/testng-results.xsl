<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://exslt.org/math" xmlns:testng="http://testng.org" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	

	<xsl:output method="html" indent="yes" omit-xml-declaration="yes"
		doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
	<xsl:output name="text" method="text" />
	<xsl:output name="xml" method="xml" indent="yes" />
	<xsl:output name="html" method="html" indent="yes"
		omit-xml-declaration="yes" />
	<xsl:output name="xhtml" method="xhtml" indent="yes"
		omit-xml-declaration="yes" />

	<xsl:param name="testNgXslt.outputDir" />
	<xsl:param name="testNgXslt.cssFile" />
	<xsl:param name="testNgXslt.showRuntimeTotals" />
	<xsl:param name="testNgXslt.reportTitle" />
	<xsl:param name="testNgXslt.sortTestCaseLinks" />
	<xsl:param name="testNgXslt.chartScaleFactor" />
	<!-- FAIL,PASS,SKIP,CONF,BY_CLASS -->
	<xsl:param name="testNgXslt.testDetailsFilter" />
	<xsl:param name="userName"/>

	<xsl:param name="fullReport"/>
	<xsl:param name="AXReport"/>
	
	<xsl:variable name="testDetailsFilter"
		select="if ($testNgXslt.testDetailsFilter) then $testNgXslt.testDetailsFilter else 'FAIL,PASS,SKIP'" />

	
    <xsl:function name="testng:getVariableSafe">
        <xsl:param name="testVar"/>
        <xsl:param name="defaultValue"/>
        <xsl:value-of select="if ($testVar) then $testVar else $defaultValue"/>
    </xsl:function>

    <xsl:function name="testng:trim">
        <xsl:param name="arg"/>
        <xsl:sequence select="replace(replace($arg,'\s+$',''),'^\s+','')"/>
    </xsl:function>

    <xsl:function name="testng:absolutePath">
        <xsl:param name="fileName"/>
        <xsl:value-of select="concat('file:////', $testNgXslt.outputDir, '/', $fileName)"/>
    </xsl:function>

    <xsl:function name="testng:safeFileName">
        <xsl:param name="fileName"/>
        <xsl:value-of select="translate($fileName, '[]{}`~!@#$%^*(){};?/\|' , '______________________')"/>
    </xsl:function>

    <xsl:function name="testng:suiteContentFileName">
        <xsl:param name="suiteElement"/>
        <xsl:value-of select="testng:safeFileName(concat($suiteElement/@name, '.html'))"/>
    </xsl:function>

    <xsl:function name="testng:suiteGroupsFileName">
        <xsl:param name="suiteElement"/>
        <xsl:value-of select="testng:safeFileName(concat($suiteElement/@name, '_groups.html'))"/>
    </xsl:function>

    <xsl:function name="testng:testCaseContentFileName">
        <xsl:param name="testCaseElement"/>
        <xsl:value-of
                select="testng:safeFileName(concat($testCaseElement/../@name, '_', $testCaseElement/@name, '.html'))"/>
    </xsl:function>

    <xsl:function name="testng:concatParams">
        <xsl:param name="params"/>
        <xsl:variable name="outputString">
            <xsl:value-of separator="," select="for $i in ($params) return $i"/>
        </xsl:variable>
        <xsl:value-of select="$outputString"/>
    </xsl:function>

    <xsl:function name="testng:testMethodStatus">
        <xsl:param name="testMethodElement"/>
        <xsl:variable name="status" select="$testMethodElement/@status"/>
        <xsl:variable name="statusClass" select="concat('testMethodStatus', $status)"/>
        <xsl:value-of select="if ($testMethodElement/@is-config) then concat($statusClass, ' testMethodStatusCONF') else $statusClass"/>
    </xsl:function>

    <xsl:function name="testng:suiteMethodsCount">
        <xsl:param name="testCasesElements"/>
        <xsl:param name="state"/>
        <xsl:value-of
                select="if ($state = '*') then count($testCasesElements/class/test-method[not(@is-config)]) else count($testCasesElements/class/test-method[(@status=$state) and (not(@is-config))])"/>
    </xsl:function>

    <xsl:function name="testng:testCaseMethodsCount">
        <xsl:param name="testCaseElement"/>
        <xsl:param name="state"/>
        <xsl:value-of
                select="if ($state = '*') then count($testCaseElement/class/test-method[not(@is-config)]) else count($testCaseElement/class/test-method[(@status=$state) and (not(@is-config))])"/>
    </xsl:function>

    <xsl:function name="testng:suiteStateClass">
        <xsl:param name="testCaseElements"/>
        <xsl:value-of select="if (count($testCaseElements/class/test-method[(@status='FAIL') and (not(@is-config))]) > 0) then 'suiteStatusFail' else 'suiteStatusPass'"/>
    </xsl:function>
	
	<xsl:function name="testng:TestClassName">
        <xsl:param name="testCaseElements"/>
        <xsl:value-of select="$testCaseElements/class/@name"/>
    </xsl:function>
 
	
    <xsl:function name="testng:formatDuration">
        <xsl:param name="durationMs"/>
        <!--Days-->
        <xsl:if test="$durationMs > 86400000">
            <xsl:value-of select="format-number($durationMs div 86400000, '#')"/>d
        </xsl:if>
        <!--Hours-->
        <xsl:if test="($durationMs > 3600000) and ($durationMs mod 86400000 > 1000)">
            <xsl:value-of select="format-number(floor(($durationMs mod 86400000) div 3600000), '#')"/>h
        </xsl:if>
        <xsl:if test="$durationMs &lt; 86400000">
            <!--Minutes-->
            <xsl:if test="($durationMs > 60000) and ($durationMs mod 3600000 > 1000)">
                <xsl:value-of select="format-number(floor(($durationMs mod 3600000) div 60000), '0')"/>m
            </xsl:if>
            <!--Seconds-->
            <xsl:if test="($durationMs > 1000) and ($durationMs mod 60000 > 1000)">
                <xsl:value-of select="format-number(floor(($durationMs mod 60000) div 1000), '#')"/>s
            </xsl:if>
        </xsl:if>
        <!--Milliseconds - only when less than a second-->
        <xsl:if test="$durationMs &lt; 1000">
            <xsl:value-of select="$durationMs"/>&#160;ms
        </xsl:if>
    </xsl:function>

    <xsl:function name="testng:isFilterSelected">
        <xsl:param name="filterName"/>
        <xsl:value-of select="contains($testDetailsFilter, $filterName)"/>
    </xsl:function>

    <xsl:template name="formField">
        <xsl:param name="label"/>
        <xsl:param name="value"/>
        <xsl:if test="$value">
            <div>
                <b>
                    <xsl:value-of select="$label"/>
                    <xsl:text>: </xsl:text>
                </b>
                <xsl:value-of select="$value"/>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="formFieldList">
        <xsl:param name="label"/>
        <xsl:param name="value"/>
        <xsl:if test="count($value) > 0">
            <div>
                <b>
                    <xsl:value-of select="$label"/>:
                </b>
                <xsl:for-each select="$value">
                    <div>
                        &#160;&#160;&#160;&#160;-
                        <xsl:value-of select="."/>
                    </div>
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="/testng-results">
	    <xsl:variable name="suiteElements" select="if (suite/@url) then document(suite/@url)/suite else suite"/>
            <html>
			<style>
			<![CDATA[		#myTestCasetable {
				table-layout: auto;
				word-wrap:break-word;
				border-collapse: collapse;
				font-family: Calibri;
				font-size: 15px;
				text-align: center;
				width: 100%;
				margin:20px;
			}
					#myTestCasetablelist {
				table-layout: auto;
				word-wrap:break-word;
				border-collapse: collapse;
				font-family: Calibri;
				font-size: 15px;
				margin: 20px;
				text-align: left;
				width: 80%;
			}
			#mytable {
				 border: 1px solid black;
    border-collapse: collapse;
	font-family:'Calibri';
	width: 98%;
			}
			#mytable TH {
	padding: 5px;
	border: 1px solid black;
	border-collapse: collapse;
	background-color: #A0A0A0;
	color:black;
	font-family:'Calibri';
	font-size:18px;
			}
			#mytable TD {
			
				border: 1px solid black;
				color: black;
				padding: 1px;
				font-size:4;
    border-collapse: collapse;
	
			}
			
			.level1 td:first-child {
				padding-left: 15px !important;
			}
			.level2 td:first-child {
				padding-left: 30px !important;
			}
			.level3 td:first-child {
				padding-left: 45px !important;
			}
			.collapse .toggle {
				cursor:Pointer;
				padding: 0 5px 0 0;
			}
			.expand .toggle {
				cursor:Pointer;
				padding: 0 5px 0 0;
			}
			.toggle {
				height: 9px;
				width: 25px;
				display: inline-block;
			}
			.#mytable img{
				cursor:Pointer;
			}	
			.testMethodDetails, .testMethodDetailsVisible { padding: 5px; background-color: #f5f5f5; margin: 1px; }
            .testMethodDetails { display: none; }
				]]>
		</style>
			<head>
			
			<script src='http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js'></script>
	
	
	<!-- *************Report in Jenkins****************-->

	<!-- Collapse & Expand Logic -->
	</head>
	<body bgcolor="#C0C0C0">
	<img src="Tesla.png" alt="Tesla logo" width="160" height="30" align="left" style="position: absolute; top: 1; left: 25;  text-align:left;"/>
	<!--<table id="myTestCasetable" border="1" style="border-style: none;"><tr style="border-style: none;">
	<td  style="border-style: none;">
	</td>
	
	<td  style="border-style: none;">
	</td>	
		<td align="center" bgcolor="#5F9EA0"><font size ="6" color="white"><b> <xsl:value-of select="$suiteElements/@name"/> Execution Report </b></font></td>
		
		<td  style="border-style: none;">
	</td>
<td  style="border-style: none;">
	</td>
		
			
	</tr></table>-->

			


	<br/>
	
	
	 <xsl:for-each select="$suiteElements">
		<xsl:variable name="suiteName" select="@name"/>									  
        <xsl:variable name="testCaseElements" select="if (test/@url) then document(test/@url)/test else test"/>
		
		<xsl:variable name="passCount" select="if (testng:suiteMethodsCount($testCaseElements, '*') > 0) then format-number(testng:suiteMethodsCount($testCaseElements, 'PASS') div testng:suiteMethodsCount($testCaseElements, '*'), '###%') else '100%'"/>
		<xsl:variable name="failCount" select="if (testng:suiteMethodsCount($testCaseElements, '*') > 0) then format-number(testng:suiteMethodsCount($testCaseElements, 'FAIL') div testng:suiteMethodsCount($testCaseElements, '*'), '###%') else '100%'"/>
		<xsl:variable name="skipCount" select="if (testng:suiteMethodsCount($testCaseElements, '*') > 0) then format-number(testng:suiteMethodsCount($testCaseElements, 'SKIP') div testng:suiteMethodsCount($testCaseElements, '*'), '###%') else '100%'"/>
	<!--
	<xsl:message>Pass count: <xsl:value-of select="substring-before($passCount, '%')"/></xsl:message>
	<xsl:message>Fail count: <xsl:value-of select="substring-before($failCount, '%')"/></xsl:message>
	<xsl:message>Skip count: <xsl:value-of select="substring-before($skipCount, '%')"/></xsl:message>
		-->							  
<center>
<Table id='myTestCasetablelist' border="2" align="center"  CELLSPACING='3' CELLPADDING='3'>
	<TR>
		<TD colspan ="6" align="center" style=" background-color: #C00000; border: 1px solid grey;">
			<font size ="4" color="white" style=" background-color: #C00000 ; font-family: 'Calibri';">
				<b><xsl:value-of select="$suiteElements/@name"/> Execution Summary
			</b></font>
		</TD>
	</TR>
	
		
	<TR>
			<TD bgcolor="#E0E0E0" width="25%">Module/Application</TD>
			<TD bgcolor="white" width="25%">
			<xsl:value-of select="$suiteElements/@name"/> 
			</TD >
			<TD bgcolor="#E0E0E0" width="25%">Passed</TD>
			<TD bgcolor='white' width="25%"><b>
			<xsl:value-of select="testng:suiteMethodsCount($testCaseElements, 'PASS')"/></b>
			</TD>	
	</TR>
	
	<TR>
		<TD bgcolor="#E0E0E0" width="25%">Environment</TD>
		<TD bgcolor="white" width="25%">
			<xsl:choose>
			<xsl:when test="$testCaseElements[1]/class/test-method/@name = 'setUp'">
			<xsl:value-of select="$testCaseElements[1]/class/test-method[@name='setUp']/params/param[@index='2']/value[1]"/>
			</xsl:when>
			<xsl:otherwise>
			<xsl:value-of select="$testCaseElements[1]/class[1]/test-method[1]/params/param[@index='2']/value[1]"/> 
			</xsl:otherwise>
			</xsl:choose>
		</TD>

		<TD bgcolor="#E0E0E0" width="25%">Failed</TD>
		<TD bgcolor='white' width="25%"><b> 
		<xsl:value-of select="testng:suiteMethodsCount($testCaseElements, 'FAIL')"/>
		</b></TD>
	</TR>

	<TR>
		<TD bgcolor="#E0E0E0" width="25%">Date</TD>
		<TD bgcolor='white' width="25%"><xsl:value-of  select="format-dateTime(current-dateTime(), '[Y1]-[M01]-[D01]')"/></TD>

		<TD bgcolor="#E0E0E0" width="25%">Skipped</TD>
		<TD bgcolor='white' width="25%"><b><xsl:value-of select="testng:suiteMethodsCount($testCaseElements, 'SKIP')"/></b></TD>
	</TR>
	
	<TR>
		<TD bgcolor="#E0E0E0" width="25%">Finish Time</TD>
		<TD bgcolor="white" width="25%"><xsl:value-of select="format-dateTime(current-dateTime(), '[H01]:[m01]:[s01]')"/></TD>
		<TD bgcolor="#E0E0E0" width="25%">Pass %</TD>
		 <!--
		  <xsl:message>Pass count1: <xsl:value-of select="if (testng:suiteMethodsCount($testCaseElements, '*') > 0) then format-number(testng:suiteMethodsCount($testCaseElements, 'PASS') div testng:suiteMethodsCount($testCaseElements, '*'), '###%') else '100%'"/></xsl:message>
		  <xsl:message>Fail count1: <xsl:value-of select="if (testng:suiteMethodsCount($testCaseElements, '*') > 0) then format-number(testng:suiteMethodsCount($testCaseElements, 'FAIL') div testng:suiteMethodsCount($testCaseElements, '*'), '###%') else '100%'"/></xsl:message>
		  -->
		<xsl:choose>
		  <xsl:when test='xs:integer(substring-before($passCount, "%")) &gt; 79'>
		 
			<TD bgcolor='LightGreen' width="25%">
				<b> <xsl:value-of select='substring-before($passCount, "%")'/></b>
			</TD>
		  </xsl:when>
		  <xsl:otherwise>
			<TD bgcolor='white' width="25%">
				<b> <xsl:value-of select='substring-before($passCount, "%")'/></b>
			</TD>
		  </xsl:otherwise>
		</xsl:choose>		
	</TR>

	<TR>
		<TD bgcolor="#E0E0E0" width="25%">Duration</TD>
		<TD bgcolor="white" width="25%">
		<xsl:value-of select="testng:formatDuration(./@duration-ms)"/> 
		</TD>
			
		<TD bgcolor="#E0E0E0" width="25%">Fail %</TD>
		
		<xsl:choose>
		  <xsl:when test='xs:integer(substring-before($failCount, "%")) &gt; 20'>
			<TD bgcolor="red" width="25%">
				<b> <xsl:value-of select='substring-before($failCount, "%")'/></b>
			</TD>
		  </xsl:when>
		  <xsl:otherwise>
			<TD bgcolor='white' width="25%">
				<b> <xsl:value-of select='substring-before($failCount, "%")'/></b>
			</TD>
		  </xsl:otherwise>
		</xsl:choose>
	</TR>
		
	<TR>
		<TD bgcolor="#E0E0E0" width="25%">Total Scripts</TD>
		<TD bgcolor="white"> <xsl:value-of select="testng:suiteMethodsCount($testCaseElements, '*')"/></TD>
		<TD bgcolor="#E0E0E0" width="25%">Skip %</TD>
		<xsl:choose>
		  <xsl:when test='xs:integer(substring-before($skipCount, "%")) &gt; 0'>
		
		<TD bgcolor='Wheat' width="25%"><b><xsl:value-of select='substring-before($skipCount, "%")'/></b>
		</TD>
		  </xsl:when>
		  <xsl:otherwise>
			<TD bgcolor='white' width="25%">
			<b><xsl:value-of select='substring-before($skipCount, "%")'/></b>
		</TD>
		</xsl:otherwise>
		</xsl:choose>	
	</TR>	
		
	</Table>	   </center>
   <!--Collapse All and Expand All links-->
 <!-- <a class="myexpand" href="#">Expand All</a> | <a class="mycollapse" href="#">Collaspe All</a>-->
 
   
<br/>

   <!--Steps Info-->
      <center>
<Table id='mytable' style=" border: 1px solid black;"  CELLSPACING='3' CELLPADDING='3'>
 <!--<Table id='mytable' CELLSPACING='3' CELLPADDING='3'>-->

<TR style="background-color: 'grey'; border: 1px solid grey;font-family:'Arial Bold';">
<TH width='2%' class='firstCol'>S.No</TH>
<TH width='16%'>Module</TH>
<TH width='7%'>Total Scripts </TH>
<TH width='4%'>Passed</TH>
<TH width='4%'>Failed</TH>
<TH width='4%'>Skipped</TH>
<!--<TH>Pass%</TH>
<TH>Fail%</TH>-->
<TH width='8%'> Execution Time </TH>
<TH width='4%' class='lastCol'>Status</TH>
<TH class='lastCol' width="35%">Final Validation/Error Message</TH>
</TR>

<xsl:variable name="counters" select="0"/>
 <xsl:for-each select="$testCaseElements">
 <xsl:sort select="started-at"/>

<TR data-depth='0' bgcolor="#E0E0E0" class='collapse level0' style="border: 1px solid black;">
 <xsl:variable name="counter" select="$counters+1" />
<TD><!--<span class='toggle'>[+]</span>-->
	<font color='black' size="4"><xsl:value-of select="position()"/></font>
		
		</TD>
		<TD><font color='black' size="4"> <xsl:value-of select="./@name"/></font></TD>
		<TD align="center"><font color='black' size="3"><xsl:value-of select="testng:testCaseMethodsCount(., '*')"/></font></TD>
		<TD align="center"><b><font color='black' size="3"><xsl:value-of select="testng:testCaseMethodsCount(., 'PASS')"/></font></b></TD>
		<TD align="center"><b><font color='black' size="3"><xsl:value-of select="testng:testCaseMethodsCount(., 'FAIL')"/></font></b></TD>
		<TD align="center"><b><font color='black' size="3"><xsl:value-of select="testng:testCaseMethodsCount(., 'SKIP')"/></font></b></TD>
		<TD align="center"><font color='black' size="3"> <xsl:value-of select="testng:formatDuration(./@duration-ms)"/></font></TD>
		<TD></TD>
		<TD></TD>
		</TR>

	<xsl:variable name="methodList" select="./class/test-method[not(@is-config)]"/>
 <xsl:variable name="category" select="'byClass'"/>
 <xsl:for-each select="$methodList">
 	<xsl:choose>
        <xsl:when test="$methodList[@description ='MultipleServices']">
		
		
		<xsl:variable name="methodId" select="concat(../@name, '_', @name, '_', $category, '_', @status, position())"/>
 <xsl:variable name="detailsId" select="concat($methodId, '_details')"/>
 <xsl:variable name="exceptionDetailsId" select="concat($methodId, '_exception')"/>
 <xsl:variable name="ClassName" select="./@name"/>
 <xsl:variable name="CaseName" select="tokenize($ClassName,'\.')"/>
 <xsl:variable name="ReportHTML" select="concat($CaseName[last()],'.html')"/>


<TR data-depth='1' class='collapse level1' bgcolor='white'  style="border: 1px solid black;">
<TD>
<font color='black' size="2"><xsl:value-of select="position()"/></font>
</TD>
<TD colspan='5' class="firstMethodCell" style="font-size: 14px; font-family:'Calibri';">
  <!--<a onclick="toggleDetailsVisibility('{$exceptionDetailsId}')">-->
   <xsl:value-of select="$CaseName[last()]"/>
     <!--</a>-->
 </TD>
 <TD align="center" style="font-size: 14px; font-family:'Calibri';">
  <xsl:value-of select="@duration-ms"/>
 </TD>
  <xsl:choose>
 <xsl:when test="./@status = 'PASS'">
<TD align="center" style="font-size: 14px; font-family:'Calibri';">
<b>
 <a href="{$ReportHTML}" style="color: green;" target="_blank"><font color="green"><xsl:value-of select="./@status"/> </font></a>
</b>
 </TD>
 </xsl:when>
 <xsl:when test="./@status = 'FAIL'">
 <TD align="center" style="font-size: 14px; font-family:'Calibri';">
<b>
 <a href="{$ReportHTML}" style="color: red;" target="_blank"><font color="red"><xsl:value-of select="./@status"/> </font></a>
</b>
 </TD>
 </xsl:when>
<xsl:otherwise>
<TD bgcolor='white' align="center" style="font-size: 14px; font-family:'Calibri';">
<b>
 <a href="{$ReportHTML}" style="color: yellow;" target="_blank"><font color="yellow"><xsl:value-of select="./@status"/> </font></a>
</b>
 </TD>
</xsl:otherwise>
</xsl:choose>
<TD bgcolor='white' style="font-size: 14px; font-family:'Calibri';">	
	<xsl:value-of select="./params/param[@index='0']/value[1]"/>	
</TD>
  </TR>
		
		 </xsl:when>
		 <xsl:otherwise>
		 
		 
		 <xsl:variable name="methodId" select="concat(../@name, '_', @name, '_', $category, '_', @status, position())"/>
 <xsl:variable name="detailsId" select="concat($methodId, '_details')"/>
 <xsl:variable name="exceptionDetailsId" select="concat($methodId, '_exception')"/>
 <xsl:variable name="ClassName" select="../@name"/>
 <xsl:variable name="CaseName" select="tokenize($ClassName,'\.')"/>
 <xsl:variable name="ReportHTML" select="concat($CaseName[last()],'.html')"/>


<TR data-depth='1' class='collapse level1' bgcolor='white'  style="border: 1px solid black;">
<TD>
<font color='black' size="2"><xsl:value-of select="position()"/></font>
</TD>
<TD colspan='5' class="firstMethodCell" style="font-size: 14px; font-family:'Calibri';">
  <!--<a onclick="toggleDetailsVisibility('{$exceptionDetailsId}')">-->
   <xsl:value-of select="$CaseName[last()]"/>
     <!--</a>-->
 </TD>
 <TD align="center" style="font-size: 14px; font-family:'Calibri';">
  <xsl:value-of select="testng:formatDuration(@duration-ms)"/>
 </TD>
  <xsl:choose>
 <xsl:when test="./@status = 'PASS'">
<TD align="center" style="font-size: 14px; font-family:'Calibri';">

 <a href="{$ReportHTML}" style="color: green;" target="_blank"><font color="green"><xsl:value-of select="./@status"/> </font></a>

 </TD>
 </xsl:when>
 <xsl:when test="./@status = 'FAIL'">
 <TD align="center" style="font-size: 14px; font-family:'Calibri';">

 <a href="{$ReportHTML}" style="color: red;" target="_blank"><font color="red"><xsl:value-of select="./@status"/> </font></a>

 </TD>
 </xsl:when>
<xsl:otherwise>
<TD align="center" style="font-size: 14px; font-family:'Calibri';">

 <a href="{$ReportHTML}" style="color: yellow;" target="_blank"><font color="yellow"><xsl:value-of select="./@status"/> </font></a>

 </TD>
</xsl:otherwise>
</xsl:choose>
<TD style="font-size: 14px; font-family:'Calibri';">
	<xsl:value-of select="./params/param[@index='0']/value[1]"/>
</TD>
  </TR>
		 
		 
		 </xsl:otherwise>
		 </xsl:choose>

 </xsl:for-each>

</xsl:for-each>	

</Table>   </center>
	  </xsl:for-each> 		
	</body>		
			
   </html>

	 <xsl:result-document href="{testng:absolutePath('mail.html')}" format="xhtml">

<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
            <html xmlns="http://www.w3.org/1999/xhtml">
			
			
			<style>
			<![CDATA[		#myTestCasetable {
				table-layout: auto;
				word-wrap:break-word;
				border-collapse: collapse;
				font-family: Times New Roman;
				font-size: 15px;
				text-align: center;
				width: 100%;
				margin:20px;
			}
					#myTestCasetablelist {
				table-layout: auto;
				word-wrap:break-word;
				border-collapse: collapse;
				font-family: Calibri;
				font-size: 15px;
				margin: 20px;
				text-align: left;
				width: 80%;
			}
			#mytable {
				 border: 1px solid black;
    border-collapse: collapse;
	font-family:'Calibri';
	width: 98%;
			}
			#mytable TH {
	padding: 5px;
	border: 1px solid black;
	border-collapse: collapse;
	background-color: #A0A0A0;
	color:black;
	font-family:'Calibri';
	
	font-size:15px;
			}
			#mytable TD {
			
				border: 1px solid black;
				color: black;
				padding: 1px;
				font-size:4;
    border-collapse: collapse;
	
			}
			
			.level1 td:first-child {
				padding-left: 15px !important;
			}
			.level2 td:first-child {
				padding-left: 30px !important;
			}
			.level3 td:first-child {
				padding-left: 45px !important;
			}
			.collapse .toggle {
				cursor:Pointer;
				padding: 0 5px 0 0;
			}
			.expand .toggle {
				cursor:Pointer;
				padding: 0 5px 0 0;
			}
			.toggle {
				height: 9px;
				width: 25px;
				display: inline-block;
			}
			.#mytable img{
				cursor:Pointer;
			}	
			.testMethodDetails, .testMethodDetailsVisible { padding: 5px; background-color: #f5f5f5; margin: 1px; }
            .testMethodDetails { display: none; }
				]]>
		</style>
			<head>
			
			<script src='http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js'></script>
		<!-- Collapse & Expand Logic -->
		
	<!-- ***********************Report in Mail Body*****************-->	
	</head>
	<!--bgcolor="#B8B8B8"-->
	<body bgcolor="#C0C0C0">
	<img src="Tesla.png" alt="Tesla logo" width="220" height="30" align="left" style="position: absolute; top: 1; left: 25;  text-align:left;"/>
	<!--<table id="myTestCasetable" border="1" style="border-style: none;"><tr style="border-style: none;">
	<td  style="border-style: none;">
	</td>
	
	<td  style="border-style: none;">
	</td>	
		<td align="center" bgcolor="#5F9EA0"><font size ="6" color="white"><b> <xsl:value-of select="$suiteElements/@name"/> Execution Report </b></font></td>
		
		<td  style="border-style: none;">
	</td>
<td  style="border-style: none;">
	</td>
		
			
	</tr></table>-->
	<!--><center >
				
                 
		
                    <h1 > 
<font size ="6" color="white" style=" background-color: #5F9EA0;font-family: 'Book Antiqua';">  <xsl:value-of select="$suiteElements/@name"/> Execution Report </font>
					
					</h1>
				</center>-->
			


	<br/>
	<table style="border-style: none;" align="center"   CELLSPACING='3' CELLPADDING='3'>
				<tr style="border-style: none;">
	<td style="border-style: none;" align="center">
					<xsl:call-template name="completeReport"/>
					</td>
					</tr>
				  </table>
	 <xsl:for-each select="$suiteElements">
		<xsl:variable name="suiteName" select="@name"/>
        <xsl:variable name="testCaseElements" select="if (test/@url) then document(test/@url)/test else test"/>
		
		<!-- variable declaration related to pass, fail & skip % -->
		<xsl:variable name="passCount" select="if (testng:suiteMethodsCount($testCaseElements, '*') > 0) then format-number(testng:suiteMethodsCount($testCaseElements, 'PASS') div testng:suiteMethodsCount($testCaseElements, '*'), '###%') else '100%'"/>
		<xsl:variable name="failCount" select="if (testng:suiteMethodsCount($testCaseElements, '*') > 0) then format-number(testng:suiteMethodsCount($testCaseElements, 'FAIL') div testng:suiteMethodsCount($testCaseElements, '*'), '###%') else '100%'"/>
		<xsl:variable name="skipCount" select="if (testng:suiteMethodsCount($testCaseElements, '*') > 0) then format-number(testng:suiteMethodsCount($testCaseElements, 'SKIP') div testng:suiteMethodsCount($testCaseElements, '*'), '###%') else '100%'"/>

		
<center>
<Table id='myTestCasetablelist' border="2" align="center"  CELLSPACING='3' CELLPADDING='3'>
	<TR>
		<TD colspan ="6" align="center" style=" background-color: #C00000 ; border: 1px solid grey;">
			<font size ="4" color="white" style=" background-color: #C00000 ; font-family: 'Calibri';">
				<b><xsl:value-of select="$suiteElements/@name"/> Execution Summary
			</b></font>
		</TD>
	</TR>
	
	<TR>
			<TD bgcolor="#E0E0E0" width="25%">Module/Application</TD>
			<TD bgcolor="white" width="25%">
			<xsl:value-of select="$suiteElements/@name"/> 
			</TD >
			
			<TD bgcolor="#E0E0E0" width="25%">Passed</TD>
			<TD bgcolor="white" width="25%">
		<xsl:value-of select="testng:suiteMethodsCount($testCaseElements, 'PASS')"/>
		</TD>
	</TR>
		
	<TR>
		<TD bgcolor="#E0E0E0">Environment</TD>
			<TD bgcolor="white" width="25%">
			<xsl:choose>
<xsl:when test="$testCaseElements[1]/class/test-method/@name = 'setUp'">
<xsl:value-of select="$testCaseElements[1]/class/test-method[@name='setUp']/params/param[@index='2']/value[1]"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$testCaseElements[1]/class[1]/test-method[1]/params/param[@index='2']/value[1]"/> 
</xsl:otherwise>
</xsl:choose>
</TD>

<TD bgcolor="#E0E0E0">Failed</TD>
<TD bgcolor="white" width="25%"><b> 
<xsl:value-of select="testng:suiteMethodsCount($testCaseElements, 'FAIL')"/>
</b></TD>
</TR>


<TR>
<TD bgcolor="#E0E0E0" width="25%">Date</TD>
<TD bgcolor="white" width="25%"><xsl:value-of  select="format-dateTime(current-dateTime(), '[Y1]-[M01]-[D01]')"/></TD>

<TD bgcolor="#E0E0E0" width="25%">Skipped</TD>
<TD bgcolor="white" width="25%"><xsl:value-of select="testng:suiteMethodsCount($testCaseElements, 'SKIP')"/></TD>
</TR>

<TR>
<TD bgcolor="#E0E0E0" width="25%">Finish Time</TD>
			<TD bgcolor="white" width="25%"><xsl:value-of select="format-dateTime(current-dateTime(), '[H01]:[m01]:[s01]')"/></TD>


    <TD bgcolor="#E0E0E0" width="25%">Pass %</TD>
			<!--
			<TD bgcolor='LightGreen' width="25%"><b> <xsl:value-of select="if (testng:suiteMethodsCount($testCaseElements, '*') > 0) then format-number(testng:suiteMethodsCount($testCaseElements, 'PASS') div testng:suiteMethodsCount($testCaseElements, '*'), '###%') else '100%'"/>
			</b></TD>
			-->
			<xsl:choose>
		  <xsl:when test='xs:integer(substring-before($passCount, "%")) &gt; 79'>
		 
			<TD bgcolor='LightGreen' width="25%">
				<b> <xsl:value-of select='substring-before($passCount, "%")'/></b>
			</TD>
		  </xsl:when>
		  <xsl:otherwise>
			<TD bgcolor='white' width="25%">
				<b> <xsl:value-of select='substring-before($passCount, "%")'/></b>
			</TD>
		  </xsl:otherwise>
		</xsl:choose>
</TR>

<TR>
 <TD bgcolor="#E0E0E0" width="25%">Duration</TD>
			<TD bgcolor="white" width="25%">
			<xsl:value-of select="testng:formatDuration(./@duration-ms)"/> 
			</TD>
			
	    
			<TD bgcolor="#E0E0E0" width="25%">Fail %</TD>
			<!--
			<TD bgcolor="#FF0000" width="25%"><b><xsl:value-of select="if (testng:suiteMethodsCount($testCaseElements, '*') > 0) then format-number(testng:suiteMethodsCount($testCaseElements, 'FAIL') div testng:suiteMethodsCount($testCaseElements, '*'), '###%') else '100%'"/>
			</b></TD>
			-->
			<xsl:choose>
		  <xsl:when test='xs:integer(substring-before($failCount, "%")) &gt; 20'>
			<TD bgcolor="red" width="25%">
				<b> <xsl:value-of select='substring-before($failCount, "%")'/></b>
			</TD>
		  </xsl:when>
		  <xsl:otherwise>
			<TD bgcolor='white' width="25%">
				<b> <xsl:value-of select='substring-before($failCount, "%")'/></b>
			</TD>
		  </xsl:otherwise>
		</xsl:choose>
		</TR>
		
	<TR>
	<TD bgcolor="#E0E0E0" width="25%">Total Scripts</TD>
			<TD bgcolor="white" width="25%"> <xsl:value-of select="testng:suiteMethodsCount($testCaseElements, '*')"/></TD>
	<TD bgcolor="#E0E0E0" width="25%">Skip %</TD>
			<!--
			<TD bgcolor='Wheat' width="25%"><b><xsl:value-of select="if (testng:suiteMethodsCount($testCaseElements, '*') > 0) then format-number(testng:suiteMethodsCount($testCaseElements, 'SKIP') div testng:suiteMethodsCount($testCaseElements, '*'), '###%') else '100%'"/>
			</b></TD>
			-->
			<xsl:choose>
		  <xsl:when test='xs:integer(substring-before($skipCount, "%")) &gt; 0'>
		
		<TD bgcolor='Wheat' width="25%"><b><xsl:value-of select='substring-before($skipCount, "%")'/></b>
		</TD>
		  </xsl:when>
		  <xsl:otherwise>
			<TD bgcolor='white' width="25%">
			<b><xsl:value-of select='substring-before($skipCount, "%")'/></b>
		</TD>
		</xsl:otherwise>
		</xsl:choose>
</TR>	
		
	</Table>   </center>	
   <!--Collapse All and Expand All links-->
 <!-- <a class="myexpand" href="#">Expand All</a> | <a class="mycollapse" href="#">Collaspe All</a>-->
 
   
<br/>

   <!--Steps Info-->
   <center>
 <Table id='mytable' style=" border: 1px solid black;"  CELLSPACING='3' CELLPADDING='3'>

<TR style="background-color: 'grey'; border: 1px solid grey;font-family:'Arial Bold';">
<TH  width='2%' class='firstCol'>S.No</TH>
<TH width='16%'>Module</TH>
<TH width='7%'>Total Scripts </TH>
<TH width='4%'>Passed</TH>
<TH width='4%'>Failed</TH>
<TH width='4%'>Skipped</TH>
<!--<TH>Pass%</TH>
<TH>Fail%</TH>-->
<TH width='8%'> Execution Time </TH>
<TH width='4%' class='lastCol'>Status</TH>
<TH width="35%" class='lastCol'>Final Validation/Error Message</TH>

</TR>

<xsl:variable name="counters" select="0"/>
 <xsl:for-each select="$testCaseElements">
<xsl:sort select="started-at"/>
<TR data-depth='0' bgcolor="#E0E0E0" class='collapse level0' style="border: 1px solid black;">
 <xsl:variable name="counter" select="$counters+1" />
<TD><!--<span class='toggle'>[+]</span>-->
	<font color='black' size="4"><b><xsl:value-of select="position()"/></b></font>
		
		</TD>
		<TD><font color='black' size="4"> <xsl:value-of select="./@name"/></font></TD>
		<TD align="center"><font color='black' size="3"><xsl:value-of select="testng:testCaseMethodsCount(., '*')"/></font></TD>
		<TD align="center"><font color='black' size="3"><xsl:value-of select="testng:testCaseMethodsCount(., 'PASS')"/></font></TD>
		<TD align="center"><font color='black' size="3"><xsl:value-of select="testng:testCaseMethodsCount(., 'FAIL')"/></font></TD>
		<TD align="center"><font color='black' size="3"><xsl:value-of select="testng:testCaseMethodsCount(., 'SKIP')"/></font></TD>
		<TD align="center"><font color='black' size="3"> <xsl:value-of select="testng:formatDuration(./@duration-ms)"/></font></TD>
		<TD></TD>
		<TD></TD>
		</TR>

	<xsl:variable name="methodList" select="./class/test-method[not(@is-config)]"/>
 <xsl:variable name="category" select="'byClass'"/>
 <xsl:for-each select="$methodList">
 <xsl:choose>
 <xsl:when test="$methodList[@description ='MultipleServices']">
		
		
		<xsl:variable name="methodId" select="concat(../@name, '_', @name, '_', $category, '_', @status, position())"/>
 <xsl:variable name="detailsId" select="concat($methodId, '_details')"/>
 <xsl:variable name="exceptionDetailsId" select="concat($methodId, '_exception')"/>
 <xsl:variable name="ClassName" select="./@name"/>
 <xsl:variable name="CaseName" select="tokenize($ClassName,'\.')"/>
 <xsl:variable name="ReportHTML" select="concat($CaseName[last()],'.html')"/>


<TR data-depth='1' class='collapse level1' bgcolor='white'  style="border: 1px solid black;">
<TD>
<font color='black' size="4"><xsl:value-of select="position()"/></font>

</TD>
<TD colspan='5' class="firstMethodCell" style="font-size: 14px; font-family:'Calibri';">
  <!--<a onclick="toggleDetailsVisibility('{$exceptionDetailsId}')">-->
   <xsl:value-of select="$CaseName[last()]"/>
     <!--</a>-->
 </TD>
 <TD align="center" style="font-size: 14px; font-family:'Calibri';">
  <xsl:value-of select="@duration-ms"/>
 </TD>
  <xsl:choose>
 <xsl:when test="./@status = 'PASS'">
<TD align="center" style="font-size: 14px; font-family:'Calibri';">

 <font color="green"><b><xsl:value-of select="./@status"/></b> </font>

 </TD>
 </xsl:when>
 <xsl:when test="./@status = 'FAIL'">
 <TD align="center" style="font-size: 14px; font-family:'Calibri';">

<font color="red"><b><xsl:value-of select="./@status"/></b> </font>

 </TD>
 </xsl:when>
<xsl:otherwise>
<TD align="center" style="font-size: 14px; font-family:'Calibri';">

 <font color="yellow"><b><xsl:value-of select="./@status"/></b> </font>

 </TD>
</xsl:otherwise>
</xsl:choose>
<TD style="font-size: 14px; font-family:'Calibri';">
	<xsl:value-of select="./params/param[@index='0']/value[1]"/>
</TD>
  </TR>
 </xsl:when>
 <xsl:otherwise>
 
 <xsl:variable name="methodId" select="concat(../@name, '_', @name, '_', $category, '_', @status, position())"/>
 <xsl:variable name="detailsId" select="concat($methodId, '_details')"/>
 <xsl:variable name="exceptionDetailsId" select="concat($methodId, '_exception')"/>
 <xsl:variable name="ClassName" select="../@name"/>
 <xsl:variable name="CaseName" select="tokenize($ClassName,'\.')"/>
 <xsl:variable name="ReportHTML" select="concat($CaseName[last()],'.html')"/>


<TR data-depth='1' class='collapse level1' bgcolor='white'  style="border: 1px solid black;">
<TD><font color='black' size="2"><xsl:value-of select="position()"/></font>
</TD>
<TD colspan='5' class="firstMethodCell" style="font-size: 14px; font-family:'Calibri';">
  <!--<a onclick="toggleDetailsVisibility('{$exceptionDetailsId}')">-->
   <xsl:value-of select="$CaseName[last()]"/>
     <!--</a>-->
 </TD>
 <TD align="center" style="font-size: 14px; font-family:'Calibri';">
  <xsl:value-of select="testng:formatDuration(@duration-ms)"/>
 </TD>
  <xsl:choose>
 <xsl:when test="./@status = 'PASS'">
<TD align="center" style="font-size: 14px; font-family:'Calibri';">

 <font color="green"><xsl:value-of select="./@status"/> </font>

 </TD>
 </xsl:when>
 <xsl:when test="./@status = 'FAIL'">
 <TD align="center" style="font-size: 14px; font-family:'Calibri';">

<font color="red"><xsl:value-of select="./@status"/> </font>

 </TD>
 </xsl:when>
<xsl:otherwise>
<TD align="center" style="font-size: 14px; font-family:'Calibri';">

 <font color="yellow"><xsl:value-of select="./@status"/> </font>

 </TD>
</xsl:otherwise>
</xsl:choose>
<TD style="font-size: 14px; font-family:'Calibri';">
	<xsl:value-of select="./params/param[@index='0']/value[1]"/>
</TD>
  </TR>
 </xsl:otherwise>
 </xsl:choose>
<!--<tr>
                <td colspan="8">
                    <div id="{$exceptionDetailsId}" class="testMethodDetails">
						<iframe src="{$ReportHTML}"
						width="100%" height="400"
						align="middle">
						</iframe>
                    </div>
                </td>
            </tr>-->
 

 </xsl:for-each>

</xsl:for-each>	

</Table>   </center>
	  </xsl:for-each> 		
	</body>		
			
   </html>
			
	  </xsl:result-document>
        </xsl:template>
		
				
	<xsl:template name="completeReport">

        <div style="margin-bottom: 16px; color:0066FF; text-align: center; font-size: 18px;">
            <a href="{$fullReport}" style="color: 0066FF;" target="_blank">
             <font style="color:0066FF;font-family:'Arial Bold,serif';" size="4"> Click here to view detailed Report</font>
            </a>
        </div>
		
    </xsl:template>
		
	<xsl:template name="AXReport">

        <div style="margin-top: 16px; color:0066FF; text-align: center; font-size: 18px;">
            <a href="{$AXReport}" style="color: black;" target="_blank">
             <font style="color:0066FF;font-family:'Arial Bold,serif';"> Click here to view AX Report</font>
            </a>
        </div>
		
		
    </xsl:template>
	
	
    <xsl:template name="powered-by">
        <div style="margin-top: 15px; color: gray; text-align: center; font-size: 9px;">
            Generated with
            <a href="http://code.google.com/p/testng-xslt/" style="color: #8888aa;" target="_blank">
                TestNG XSLT
            </a>
        </div>
    </xsl:template>

</xsl:stylesheet>