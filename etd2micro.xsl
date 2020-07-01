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

  <!-- 007: he u -->
  <xsl:template match="marc:controlfield[@tag='007']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:text>he u|||||||||</xsl:text>
    </xsl:copy>
  </xsl:template>

  <!-- 008/23: b -->
  <xsl:template match="marc:controlfield[@tag='008']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:value-of select="concat(substring(., 1, 23), 'b', substring(., 25))" />
    </xsl:copy>
  </xsl:template>

  <!-- 264: second indicator: 0 -->
  <xsl:template match="marc:datafield[@tag='264']/@ind2">
    <xsl:attribute name="ind2">
      <xsl:text>0</xsl:text>
    </xsl:attribute>
  </xsl:template>

  <!-- 300‡a: remove “1 online resource” to just leave page numbers -->
  <xsl:template match="marc:datafield[@tag='300']/marc:subfield[@code='a']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:choose>
        <xsl:when test="substring-after(., '1 online resource (') and substring-before(., ')')">
          <xsl:value-of select="substring-before(substring-after(., '1 online resource ('), ')')" />
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
      <xsl:text>microfiche</xsl:text>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="marc:datafield[@tag='338']/marc:subfield[@code='b']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:text>he</xsl:text>
    </xsl:copy>
  </xsl:template>

  <!-- 533: Replace with ProQuest -->
  <!-- if existing -->
  <xsl:template match="marc:datafield[@tag='533']">
    <xsl:call-template name="proquest533" />
  </xsl:template>
  <!-- if missing, put it after the 520, since we know that is there -->
  <xsl:template match="marc:datafield[@tag='520' and not(../marc:datafield[@tag='533'])]">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
    <xsl:call-template name="proquest533" />
  </xsl:template>

  <xsl:template name="proquest533">
    <marc:datafield tag="533" ind1=" " ind2=" ">
      <marc:subfield code="a"><xsl:text>Microfiche.</xsl:text></marc:subfield>
      <marc:subfield code="b"><xsl:text>Ann Arbor, Michigan :</xsl:text></marc:subfield>
      <marc:subfield code="c"><xsl:text>ProQuest, LLC</xsl:text></marc:subfield>
    </marc:datafield>
  </xsl:template>

  <!-- remove 856 -->
  <xsl:template match="marc:datafield[@tag='856']">
  </xsl:template>

</xsl:stylesheet>
