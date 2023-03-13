<?xml version="1.0" encoding="utf-8"?>
<!--
	This stylesheet can be used to generate a JUnit XML from a gotest JSON output.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array"
  exclude-result-prefixes="#all"
  expand-text="yes">

  <xsl:output method="xml" indent="yes" />

  <!-- timestamp on testsuite and testcase -->
  <xsl:template match=".">
    <xsl:variable name="array" select="." />
    <xsl:variable name="range" select="1 to (array:size($array))" />
    <testsuites>
      <xsl:for-each-group select="$range" group-by="tokenize($array(.)?Test,'/')[1]">
        <xsl:variable name="package" select="$array(.)?Package" />
        <xsl:variable name="suite" select="current-grouping-key()" />
        <xsl:variable name="tests" select="current-group()" />
        <xsl:variable name="outcomes" select="$tests[$array(.)?Elapsed instance of xs:double]" />
        <xsl:variable name="failures" select="$outcomes[$array(.)?Action = 'fail']" />
        <xsl:variable name="skipped" select="$outcomes[$array(.)?Action = 'skip']" />
        <xsl:variable name="times" as="xs:double *">
          <xsl:for-each select="$outcomes">
            <xsl:sequence select="$array(.)?Elapsed" />
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="timestamps" as="xs:dateTime *">
          <xsl:for-each select="$tests">
            <xsl:sequence select="xs:dateTime($array(.)?Time)" />
          </xsl:for-each>
        </xsl:variable>
        <testsuite package="{$package}" name="{$suite}" tests="{count($outcomes)}"
          failures="{count($failures)}" skipped="{count($skipped)}" time="{sum($times)}"
          timestamp="{min($timestamps)}">
          <xsl:for-each-group select="$tests" group-by="$array(.)?Test">
            <xsl:variable name="test" select="current-grouping-key()" />
            <xsl:variable name="info" select="current-group()" />
            <xsl:variable name="result"
              select="$array($info[$array(.)?Elapsed instance of xs:double])" />
            <xsl:variable name="output">
              <xsl:for-each select="$info[$array(.)?Action = 'output']">
                <value>{replace($array(.)?Output, '\\n', '&#xa;')}</value>
              </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="timestamps" as="xs:dateTime *">
              <xsl:for-each select="$info">
                <xsl:sequence select="xs:dateTime($array(.)?Time)" />
              </xsl:for-each>
            </xsl:variable>
            <testcase name="{$test}" time="{$result?Elapsed}" timestamp="{min($timestamps)}">
              <xsl:choose>
                <xsl:when test="$result?Action = 'fail'">
                  <failure message="FAIL">{$output}</failure>
                </xsl:when>
                <xsl:when test="$result?Action = 'skip'">
                  <skipped message="SKIP"></skipped>
                  <system-out>{$output}</system-out>
                </xsl:when>
                <otherwise>
                  <system-out>{$output}</system-out>
                </otherwise>
              </xsl:choose>
            </testcase>
          </xsl:for-each-group>
        </testsuite>
      </xsl:for-each-group>
    </testsuites>
  </xsl:template>

</xsl:stylesheet>
