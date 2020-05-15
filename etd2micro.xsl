<?xml version="1.0" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:marc="http://www.loc.gov/MARC21/slim"
	exclude-result-prefixes="xsi xsl"
>
	
  <!-- Identity -->
  <xsl:template match="/ | @* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <!-- 007/0 & 007/1: he -->
  <xsl:template match="marc:controlfield[@tag='007']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:value-of select="concat('he', substring(., 3))" />
    </xsl:copy>
  </xsl:template>

  <!-- 008/23: b -->
  <xsl:template match="marc:controlfield[@tag='008']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:value-of select="concat(substring(., 1, 23), 'b', substring(., 25))" />
    </xsl:copy>
  </xsl:template>

  <!-- 300‡a: replace “1 online resource” with “microfiche” -->
  <xsl:template match="marc:datafield[@tag='300']/marc:subfield[@code='a']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:choose>
        <xsl:when test="substring-before(., '1 online resource') or substring-after(., '1 online resource')">
          <xsl:value-of select="concat(substring-before(., '1 online resource'), 'microfiche', substring-after(., '1 online resource'))" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="." />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- 337: ‡a microform ‡b h ‡2 rdamedia -->
  <xsl:template match="marc:datafield[@tag='337']/marc:subfield[@code='a']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:text>microform</xsl:text>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="marc:datafield[@tag='337']/marc:subfield[@code='b']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:text>h</xsl:text>
    </xsl:copy>
  </xsl:template>

  <!-- 338: ‡a microfiche ‡b he ‡2 rdacarrier -->
  <xsl:template match="marc:datafield[@tag='338']/marc:subfield[@code='a']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:text>microform</xsl:text>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="marc:datafield[@tag='338']/marc:subfield[@code='b']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:text>he</xsl:text>
    </xsl:copy>
  </xsl:template>

  <!-- remove 856 -->
  <xsl:template match="marc:datafield[@tag='856']">
  </xsl:template>

</xsl:stylesheet>
