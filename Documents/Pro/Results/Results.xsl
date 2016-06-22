<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html>
      <head runat="server">
        <style type="text/css">
          .tableHeader
          {
          color: #0000FF;
          font-weight: bold;
          font-size: 15px;
          font-family: Verdana;
          background-color: #D9D9FF;
          text-align: center;
          padding: 3px 3px 1px;
          }
          .tableFooter
          {
          color: #AAAAAA;
          font-size: 13px;
          font-family: Verdana;
          text-align: center;
          padding: 3px 3px 1px;
          }
          .tableBorder
          {
          padding-top: 5px;
          padding-bottom: 5px;
          padding-left: 10px;
          border-top: 3px solid #ccc;
          border-bottom: 3px solid #ccc;
          border-left: 3px solid #ccc;
          border-right: 3px solid #ccc;
          border-width: 2px;
          border-color: #D9D9FF;
          }
          .table_hl
          {
          margin: 2px;
          padding: 5px;
          color: #990000;
          font-weight: bold;
          font-size: 15px;
          font-family: Times New Roman;
          border-top: 1px solid #669;
          border-bottom: 1px solid #669;
          border: 1px solid #666699;
          text-align: center;
          }
          .table_cell
          {
          margin: 2px;
          padding: 5px;
          color: #000000;
          font-size: 13px;
          font-family: Verdana;
          border-top: 1px solid #669;
          border-bottom: 1px solid #669;
          border: 1px solid #666699;
          text-align: left;
          }
          .envDetCaption
          {
          padding: 2px;
          font-family: Times New Roman;
          font-size: 15px;
          color: #000000;
          font-weight: bold;
          }
          .envDetValue
          {
          font-family: Times New Roman;
          font-size: 14px;
          color: #000000;
          }
          .envDetColon
          {
          font-family: verdana;
          font-size: 11px;
          font-weight: bold;
          color: #000000;
          }
        </style>
      </head>
      <body style="font-family: Verdana" bgcolor='#A4A4A4'>
	  
	<img src="logo.png" alt="logo" width="60" height="50" align="left" style="position: absolute; top: 1; left: 15;  text-align:left;"/>

<br/>

		<form id="form1" runat="server">
		
          <table width="99%">
            <tr>
<br/>  
            </tr>
            <tr>
              <td>
                <table cellpadding="0" cellspacing="0" width="70%" bgcolor='#F7F2E0' border-color='#FFFFFF' border="1" align="center">
   <tr>
                    <td class="tableHeader">
                      Automation Execution Summary
                    </td>
                  </tr>
                  <tr>
                    <td class="tableBorder">
                      <table cellpadding="0" cellspacing="0" style="border-color: Black; overflow: visible" border="1" width="98%">                    
                      
<tr>
<td width="15%" class="envDetCaption">
                            Test Script ID
                          </td><td width="40%" class="envDetValue"><xsl:value-of select="TestCase/Details/TestCaseName"/></td><td width="15%" class="envDetCaption">
                            Start Time
                          </td><td width="25%" class="envDetValue"><xsl:value-of select="TestCase/Details/StartTime"/></td>
</tr>
<tr>
<td width="15%" class="envDetCaption">
                            Environment
                          </td><td width="40%" class="envDetValue"><xsl:value-of select="TestCase/Details/Environment"/></td><td width="15%" class="envDetCaption">
                            End Time
                          </td><td width="25%" class="envDetValue"><xsl:value-of select="TestCase/Details/EndTime"/></td>
</tr>
<tr>
<td width="15%" class="envDetCaption">
                            Module Name
                          </td><td width="40%" class="envDetValue"><xsl:value-of select="TestCase/Details/ModuleName"/></td><td width="15%" class="envDetCaption">
                            Test Duration
                          </td><td width="25%" class="envDetValue"><xsl:value-of select="TestCase/Details/Duration"/></td>
</tr>
<tr>
<td width="15%" class="envDetCaption">
                            Test Type
                          </td><td style="font-weight:bold" width="40%" class="envDetValue">
<xsl:value-of select="TestCase/Details/ProjectName"/>                          
                          </td>
						<td width="15%" class="envDetCaption">
                            Execution Status
                          </td> <xsl:choose>
                            <xsl:when test="TestCase/Details/Result = 'Pass'">
                              <td class="envDetValue" width="25%" style="color:Green; font-weight:bold">
                                Pass
                              </td>
                            </xsl:when>
                            <xsl:when test="TestCase/Details/Result = 'Fail'">
                              <td class="envDetValue" width="25%" style="color:Red; font-weight:bold">
                                Fail
                              </td>
                            </xsl:when>
                            <xsl:when test="TestCase/Details/Result = 'Warning'">
                              <td class="envDetValue" width="25%" style="color:Blue; font-weight:bold">
                                Warning
                              </td>
                            </xsl:when>
                            <xsl:otherwise>
                              <td class="envDetValue" width="25%" style="color:Black; font-weight:bold">
                                <xsl:value-of select="TestCase/Details/Result"/>
                              </td>
                            </xsl:otherwise>
                          </xsl:choose>
      
</tr>
<tr>
<td width="15%" class="envDetCaption">
                            OS-Browser
                          </td><td width="40%" class="envDetValue"> <xsl:value-of select="TestCase/Details/OSBrowser"/></td>
						  <td width="15%" class="envDetCaption">
                            Executed By
                          </td><td width="25%" class="envDetValue">
                               <xsl:value-of select="TestCase/Details/User"/>
                              </td>
                        </tr>                        
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <xsl:if test="(count(TestCase/Steps/Step) > 0)">
            <tr>
              <td><br/></td>
            </tr>
            <tr>
              <td>
                <table width="80%" cellspacing="0" cellpadding="0"  align="center">
                  <tr>
                    <td>
                      <table width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                          <td class="tableHeader">
                            Test Summary
                          </td>
                        </tr>
                        <tr>
                          <td class="tableBorder">
                            <table cellpadding="0" cellspacing="0" border="0" width="99%" border-spacing='2px' bgcolor='#FFFFFF' border-color='#FFFFFF' align='center'>
  <tr bgcolor='#B40404'>
                                <td class="table_hl" width="3%">
								<b>
<font color='#FFFFFF'>

                                  SNo.
								   </font>
								  </b>
                                </td>
                                <td class="table_hl" width="36%">
								<b>
<font color='#FFFFFF'>
                                  Test Steps
								  </font>
								  </b>
                                </td>
                                <td class="table_hl" width="36%">
									<b>
<font color='#FFFFFF'>
                                  Actual
								  </font>
								  </b>
                                </td>
                                <td class="table_hl" width="9%">
								<b>
<font color='#FFFFFF'>
                                  Status
								  </font>
								  </b>
                                </td>
                                <!--<td class="table_hl" width="17%">
                                  Date
                                </td>-->
                
				</tr>
			
				<xsl:for-each select="TestCase/Steps/Step">
				
							
   <xsl:choose>
          <xsl:when test="starts-with(Expected,' ')">
             <tr bgcolor="#CCFFFF">

							
                                  <td class="table_cell" width="3%">
                                    <xsl:value-of select="StepNumber"/>.     
                                  </td>
								  
		
                                  <td class="table_cell" width="36%">
                                    		  
                                    <xsl:value-of select="Expected"/>
                               </td>
                                  <td class="table_cell" width="36%">
								 
				   <xsl:value-of select="Actual"/>				    
                                    <xsl:if test="Screenshot">	
				    <br/>
				    <a>
				    <xsl:attribute name="href">
				    <xsl:value-of select="Screenshot"/>
				    </xsl:attribute>
    				    <xsl:value-of select="Screenshot"/>
				    </a>
					
    				    </xsl:if>
					
				    </td>
				
                                  <xsl:choose>
                                    <xsl:when test="Status = 'Pass'">
                                      <td class="table_cell" width="9%" style="color: green; font-weight: bold">
                                        Pass
                                      </td>
                                    </xsl:when>
                                    <xsl:when test="Status = 'Fail'">
                                      <td class="table_cell" width="9%" style="color: red; font-weight: bold">
                                        Fail
                                      </td>
                                    </xsl:when>
                                    <xsl:when test="Status = 'Warning'">
                                      <td class="table_cell" width="9%" style="color: Blue; font-weight: bold">
                                        Warning
                                      </td>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <td class="table_cell" width="9%" style="color: black; font-weight: bold">
                                        <xsl:value-of select="Status"/>
                                      </td>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  <!--<td class="table_cell" width="17%">
                                    <xsl:value-of select="DateTime"/>
                                  </td>-->
                                </tr>
				

          </xsl:when>
          <xsl:otherwise>
          



                                <tr>

							
                                  <td class="table_cell" width="3%">
                                    <xsl:value-of select="StepNumber"/>.     
                                  </td>
								  
		
                                  <td class="table_cell" width="36%">
                                    <xsl:value-of select="Expected"/>
										
                                  </td>
                                  <td class="table_cell" width="36%">
				   <xsl:value-of select="Actual"/>				    
                                    <xsl:if test="Screenshot">	
				    <br/>
				    <a>
				    <xsl:attribute name="href">
				    <xsl:value-of select="Screenshot"/>
				    </xsl:attribute>
    				    <xsl:value-of select="Screenshot"/>
				    </a>
    				    </xsl:if>
				    </td>
				
                                  <xsl:choose>
                                    <xsl:when test="Status = 'Pass'">
                                      <td class="table_cell" width="9%" style="color: green; font-weight: bold">
                                        Pass
                                      </td>
                                    </xsl:when>
                                    <xsl:when test="Status = 'Fail'">
                                      <td class="table_cell" width="9%" style="color: red; font-weight: bold">
                                        Fail
                                      </td>
                                    </xsl:when>
                                    <xsl:when test="Status = 'Warning'">
                                      <td class="table_cell" width="9%" style="color: Blue; font-weight: bold">
                                        Warning
                                      </td>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <td class="table_cell" width="9%" style="color: black; font-weight: bold">
                                        <xsl:value-of select="Status"/>
                                      </td>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  <!--<td class="table_cell" width="17%">
                                    <xsl:value-of select="DateTime"/>
                                  </td>-->
                                </tr>
				
  
          </xsl:otherwise>
        </xsl:choose>

                              </xsl:for-each>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            </xsl:if>
            <tr>
              <td class="tableFooter">
                <br>
                  <br>
                    Generated by GAT IP V1.0. Prolifics Corporation Proprietary.
                  </br>
                </br>
              </td>
            </tr>
          </table>
        </form>
    
  </body>
    </html>
  </xsl:template>
</xsl:stylesheet>