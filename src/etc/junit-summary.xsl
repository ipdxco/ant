<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  <xsl:character-map name="no-control-characters">
    <xsl:output-character character="&#127;" string="&amp;#127;" />
    <xsl:output-character character="&#128;" string="&amp;#128;" />
    <xsl:output-character character="&#129;" string="&amp;#129;" />
    <xsl:output-character character="&#130;" string="&amp;#130;" />
    <xsl:output-character character="&#131;" string="&amp;#131;" />
    <xsl:output-character character="&#132;" string="&amp;#132;" />
    <xsl:output-character character="&#133;" string="&amp;#133;" />
    <xsl:output-character character="&#134;" string="&amp;#134;" />
    <xsl:output-character character="&#135;" string="&amp;#135;" />
    <xsl:output-character character="&#136;" string="&amp;#136;" />
    <xsl:output-character character="&#137;" string="&amp;#137;" />
    <xsl:output-character character="&#138;" string="&amp;#138;" />
    <xsl:output-character character="&#139;" string="&amp;#139;" />
    <xsl:output-character character="&#140;" string="&amp;#140;" />
    <xsl:output-character character="&#141;" string="&amp;#141;" />
    <xsl:output-character character="&#142;" string="&amp;#142;" />
    <xsl:output-character character="&#143;" string="&amp;#143;" />
    <xsl:output-character character="&#144;" string="&amp;#144;" />
    <xsl:output-character character="&#145;" string="&amp;#145;" />
    <xsl:output-character character="&#146;" string="&amp;#146;" />
    <xsl:output-character character="&#147;" string="&amp;#147;" />
    <xsl:output-character character="&#148;" string="&amp;#148;" />
    <xsl:output-character character="&#149;" string="&amp;#149;" />
    <xsl:output-character character="&#150;" string="&amp;#150;" />
    <xsl:output-character character="&#151;" string="&amp;#151;" />
    <xsl:output-character character="&#152;" string="&amp;#152;" />
    <xsl:output-character character="&#153;" string="&amp;#153;" />
    <xsl:output-character character="&#154;" string="&amp;#154;" />
    <xsl:output-character character="&#155;" string="&amp;#155;" />
    <xsl:output-character character="&#156;" string="&amp;#156;" />
    <xsl:output-character character="&#157;" string="&amp;#157;" />
    <xsl:output-character character="&#158;" string="&amp;#158;" />
    <xsl:output-character character="&#159;" string="&amp;#159;" />
  </xsl:character-map>
  <xsl:output method="html" indent="yes" encoding="UTF-8" use-character-maps="no-control-characters"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />
  <xsl:decimal-format decimal-separator="." grouping-separator="," />
  <!--
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       https://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 -->

  <!--

 Sample stylesheet to be used with Ant JUnitReport output.

 It creates a non-framed report that can be useful to send via
 e-mail or such.

-->
  <xsl:template match="testsuites">
    <html>
      <body>
        <xsl:call-template name="summary" />
        <xsl:call-template name="failures" />
      </body>
    </html>
  </xsl:template>

  <xsl:template name="summary">
    <h4>Summary</h4>
    <xsl:variable name="testCount" select="sum(testsuite/@tests)" />
    <xsl:variable name="failureCount" select="sum(testsuite/@failures)" />
    <xsl:variable name="errorCount" select="sum(testsuite/@errors)" />
    <xsl:variable name="skippedCount" select="sum(testsuite/@skipped)" />
    <table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
      <tr valign="top" align="left">
        <th>Tests</th>
        <th>Failures</th>
        <th>Errors</th>
        <th>Skipped</th>
      </tr>
      <tr valign="top" align="left">
        <td>
          <xsl:value-of select="$testCount" />
        </td>
        <td>
          <xsl:value-of select="$failureCount" />
        </td>
        <td>
          <xsl:value-of select="$errorCount" />
        </td>
        <td>
          <xsl:value-of select="$skippedCount" />
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="failures">
    <xsl:variable name="failureCount" select="sum(testsuite/@failures)" />
    <xsl:variable name="errorCount" select="sum(testsuite/@errors)" />
    <xsl:if test="$failureCount != 0 or $errorCount != 0">
      <h4>Failures/Errors</h4>
      <table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
        <tr valign="top" align="left">
          <th>Package</th>
          <th>Test Suite</th>
          <th>Test Case</th>
          <th>Status</th>
        </tr>
        <xsl:for-each select="testsuite/error">
          <xsl:sort select="../@name" />
          <xsl:sort select="../@package" />
          <tr valign="top" align="left">
            <td><xsl:value-of select="../@package"/></td>
            <td><xsl:value-of select="../@name"/></td>
            <td>Error</td>
            <td><xsl:call-template name="display-failures" /></td>
          </tr>
        </xsl:for-each>
        <xsl:for-each select="testsuite/testcase/(failure|error)">
          <xsl:sort select="../@name" />
          <xsl:sort select="../../@name" />
          <xsl:sort select="../../@package" />
          <tr valign="top" align="left">
            <td><xsl:value-of select="../../@package"/></td>
            <td><xsl:value-of select="../../@name"/></td>
            <td><xsl:value-of select="../@name"/></td>
            <td><xsl:call-template name="display-failures" /></td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>

  <!-- Style for the error, failure and skipped in the testcase template -->
  <xsl:template name="display-failures">
    <xsl:choose>
      <xsl:when test="not(@type) and not(@message)">N/A</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(concat(@type, ' ', @message))" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- display the stacktrace -->
    <pre><xsl:value-of select="."/></pre>
  </xsl:template>

</xsl:stylesheet>
