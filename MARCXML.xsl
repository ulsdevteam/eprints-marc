<?xml version="1.0" encoding="UTF-8"?>
<!--
EPrint to MARCXML transformation
EPrints 3.3.x compatible stylesheet, intended for use with the plugin EPrints::Plugin::Export::XSLT.

Copyright (c) 2016, University of Pittsburgh
Authored by Clinton Graham <ctgraham@pitt.edu> (412-383-1057) for the University Library System

This is free software, licensed under (at your option):
	the Perl artistic license (http://dev.perl.org/licenses/artistic.html)
or
	the GNU General Public License, version 1 or later (http://www.gnu.org/licenses/licenses.en.html)
-->
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:e="http://eprints.org/ep2/data/2.0" 
	xmlns:ept="http://eprints.org/ep2/xslt/1.0" 
	xmlns:exsl="http://exslt.org/common" 
	xmlns:marc="http://www.loc.gov/MARC21/slim" 
	exclude-result-prefixes="xsi xsl e ept exsl"
	ept:name="MARCXML"
	ept:visible="all"
	ept:advertise="1"
	ept:accept="list/eprint dataobj/eprint"
	ept:mimetype="application/xml; charset=utf-8"
	ept:qs="0.1"
>
<xsl:output method="xml" indent="yes" />

<xsl:param name="results" />

<xsl:template match="text()" />

<xsl:template match="/ept:template">
<marc:collection>
	<xsl:value-of select="$results" />
</marc:collection>
</xsl:template>

<xsl:template match="/e:eprints/e:eprint">
<marc:record>
	<marc:leader>                  a</marc:leader>
	<xsl:if test="normalize-space(e:isbn)">
		<marc:datafield tag="020" ind1="" ind2="">
			<marc:subfield code="a"><xsl:value-of select="e:isbn" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="normalize-space(e:issn)">
		<marc:datafield tag="022" ind1="" ind2="">
			<marc:subfield code="a"><xsl:value-of select="e:issn" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="normalize-space(e:composition_type)">
		<marc:datafield tag="047" ind1="" ind2="">
			<!-- TODO: translate to controlled vocabulary -->
			<marc:subfield code="a"><xsl:value-of select="e:composition_type" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="count(e:creators/e:item/e:name) = 1">
			<marc:datafield tag="100" ind1="1" ind2="">
				<marc:subfield code="a"><xsl:value-of select="e:creators/e:item/e:name/e:family" /><xsl:if test="normalize-space(e:creators/e:item/e:name/e:given)"><xsl:text>, </xsl:text><xsl:value-of select="e:creators/e:item/e:name/e:given" /></xsl:if></marc:subfield>
				<xsl:if test="normalize-space(e:creators/e:item/e:name/e:lineage)"><marc:subfield code="b"><xsl:value-of select="e:creators/e:item/e:name/e:lineage" /></marc:subfield></xsl:if>
				<xsl:if test="normalize-space(e:creators/e:item/e:name/e:honourific)"><marc:subfield code="c"><xsl:value-of select="e:creators/e:item/e:name/e:honourific" /></marc:subfield></xsl:if>
			</marc:datafield>
		</xsl:when>
		<xsl:when test="count(e:corp_creators/e:item) = 1">
			<marc:datafield tag="110" ind1="2" ind2="">
				<marc:subfield code="a"><xsl:value-of select="e:corp_creators/e:item" /></marc:subfield>
			</marc:datafield>
		</xsl:when>
		<xsl:when test="count(e:event_title) = 1">
			<marc:datafield tag="111" ind1="2" ind2="">
				<marc:subfield code="a"><xsl:value-of select="e:event_title" /></marc:subfield>
				<xsl:if test="normalize-space(e:event_location)">
					<marc:subfield code="c"><xsl:value-of select="e:event_location" /></marc:subfield>
				</xsl:if>
				<xsl:if test="normalize-space(e:event_date)">
				<marc:subfield code="d"><xsl:value-of select="e:event_date" /></marc:subfield>
				</xsl:if>
			</marc:datafield>
		</xsl:when>
		<xsl:when test="count(e:creators/e:item/e:name)">
			<marc:datafield tag="100" ind1="1" ind2="">
				<marc:subfield code="a"><xsl:value-of select="e:creators/e:item[1]/e:name/e:family" /><xsl:if test="normalize-space(e:creators/e:item[1]/e:name/e:given)"><xsl:text>, </xsl:text><xsl:value-of select="e:creators/e:item[1]/e:name/e:given" /></xsl:if></marc:subfield>
				<xsl:if test="normalize-space(e:creators/e:item[1]/e:name/e:lineage)"><marc:subfield code="b"><xsl:value-of select="e:creators/e:item[1]/e:name/e:lineage" /></marc:subfield></xsl:if>
				<xsl:if test="normalize-space(e:creators/e:item[1]/e:name/e:honourific)"><marc:subfield code="c"><xsl:value-of select="e:creators/e:item[1]/e:name/e:honourific" /></marc:subfield></xsl:if>
			</marc:datafield>
		</xsl:when>
		<xsl:when test="count(e:corp_creators/e:item)">
			<marc:datafield tag="110" ind1="2" ind2="">
				<marc:subfield code="a"><xsl:value-of select="e:corp_creators/e:item[1]" /></marc:subfield>
			</marc:datafield>
		</xsl:when>
	</xsl:choose>
	<xsl:if test="normalize-space(e:title)">
		<marc:datafield tag="245" ind1="0" ind2="0">
			<marc:subfield code="a"><xsl:value-of select="e:title" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="normalize-space(e:book_title)">
		<marc:datafield tag="246" ind1="0" ind2="3">
			<marc:subfield code="a"><xsl:value-of select="e:book_title" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="normalize-space(e:publisher)">
		<marc:datafield tag="260" ind1="" ind2="">
			<xsl:if test="normalize-space(e:publisher)">
			<marc:subfield code="a"><xsl:value-of select="e:publisher" /></marc:subfield>
			</xsl:if>
			<xsl:if test="normalize-space(e:place_of_pub)">
				<marc:subfield code="b"><xsl:value-of select="e:place_of_pub" /></marc:subfield>
			</xsl:if>
			<xsl:if test="normalize-space(e:date)">
				<marc:subfield code="c"><xsl:value-of select="e:date" /></marc:subfield>
			</xsl:if>
		</marc:datafield>
	</xsl:if> 
	<xsl:for-each select="e:num_pieces|e:pagerange|e:pages">
		<marc:datafield tag="300" ind1="" ind2="">
			<marc:subfield code="a">
				<xsl:if test="local-name(.) = 'pagerange'">
					<xsl:text>pages </xsl:text>
				</xsl:if>
				<xsl:value-of select="." />
				<xsl:if test="local-name(.) = 'pages'">
					<xsl:text> pages</xsl:text>
				</xsl:if>
			</marc:subfield>
		</marc:datafield>
	</xsl:for-each>
	<xsl:if test="normalize-space(e:volume)">
		<marc:datafield tag="362" ind1="0" ind2="">
			<marc:subfield code="a">
				<xsl:text>Vol. </xsl:text>
				<xsl:value-of select="e:volume" />
				<xsl:if test="normalize-space(e:number)">
					<xsl:text>, No. </xsl:text>
					<xsl:value-of select="e:number" />
				</xsl:if>
			</marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="normalize-space(e:series)">
		<marc:datafield tag="490" ind1="0" ind2="">
			<marc:subfield code="a"><xsl:value-of select="e:series" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:for-each select="e:note">
		<marc:datafield tag="500" ind1="" ind2="">
			<marc:subfield code="a"><xsl:value-of select="." /></marc:subfield>
		</marc:datafield>
	</xsl:for-each>
	<xsl:if test="normalize-space(e:abstract)">
		<marc:datafield tag="520" ind1="3" ind2="">
			<marc:subfield code="a"><xsl:value-of select="e:abstract" /></marc:subfield>
		</marc:datafield>
	</xsl:if> 
	<xsl:if test="normalize-space(e:output_media)">
		<marc:datafield tag="533" ind1="" ind2="">
			<marc:subfield code="a"><xsl:value-of select="e:output_media" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="count(e:subjects/e:item)">
		<xsl:for-each select="e:subjects/e:item">
			<marc:datafield tag="650" ind1="" ind2="4">
				<marc:subfield code="a"><xsl:value-of select="." /></marc:subfield>
			</marc:datafield>
		</xsl:for-each>
	</xsl:if>
	<xsl:if test="normalize-space(e:keywords)">
		<xsl:variable name="keywordList">
			<xsl:call-template name="tokenize">
				<xsl:with-param name="inputString" select="e:keywords" />
				<xsl:with-param name="tokenString">
					<xsl:choose>
						<xsl:when test="not(contains(e:keywords, ';'))">
							<xsl:text>,</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<marc:datafield tag="653" ind1="" ind2="">
		<xsl:for-each select="exsl:node-set($keywordList)/token">
				<marc:subfield code="a"><xsl:value-of select="." /></marc:subfield>
			</xsl:for-each>
		</marc:datafield>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="count(e:creators/e:item/e:name) = 1 or count(e:corp_creators/e:item) = 1 or count(e:event_title) = 1" />
		<xsl:when test="count(e:creators/e:item/e:name)">
			<xsl:for-each select="e:creators/e:item/e:name">
				<xsl:if test="position()>1">
					<marc:datafield tag="700" ind1="1" ind2="">
						<marc:subfield code="a"><xsl:value-of select="e:family" /><xsl:if test="normalize-space(e:given)"><xsl:text>, </xsl:text><xsl:value-of select="e:given" /></xsl:if></marc:subfield>
						<xsl:if test="normalize-space(e:lineage)"><marc:subfield code="b"><xsl:value-of select="e:lineage" /></marc:subfield></xsl:if>
						<xsl:if test="normalize-space(e:honourific)"><marc:subfield code="c"><xsl:value-of select="e:honourific" /></marc:subfield></xsl:if>
			</marc:datafield>
				</xsl:if>
		</xsl:for-each>
		</xsl:when>
		<xsl:when test="count(e:corp_creators/e:item)">
			<xsl:for-each select="e:corp_creators/e:item">
				<xsl:if test="position()>1">
					<marc:datafield tag="710" ind1="2" ind2="">
						<marc:subfield code="a"><xsl:value-of select="." /></marc:subfield>
					</marc:datafield>
	</xsl:if>
			</xsl:for-each>
		</xsl:when>
	</xsl:choose>
	<xsl:for-each select="e:editors|e:producers|e:conductors|e:lyracists|e:exhibitors">
		<xsl:for-each select="e:item/e:name">
		<marc:datafield tag="700" ind1="1" ind2="">
				<marc:subfield code="a"><xsl:value-of select="e:family" /><xsl:if test="normalize-space(e:given)"><xsl:text>, </xsl:text><xsl:value-of select="e:given" /></xsl:if></marc:subfield>
				<xsl:if test="normalize-space(e:lineage)"><marc:subfield code="b"><xsl:value-of select="e:lineage" /></marc:subfield></xsl:if>
				<xsl:if test="normalize-space(e:honourific)"><marc:subfield code="c"><xsl:value-of select="e:honourific" /></marc:subfield></xsl:if>
		</marc:datafield>
	</xsl:for-each> 
	</xsl:for-each> 
	<xsl:if test="normalize-space(e:institution)">
		<marc:datafield tag="710" ind1="2" ind2="">
			<marc:subfield code="a"><xsl:value-of select="e:institution" /></marc:subfield>
		</marc:datafield>
	</xsl:if> 
	<xsl:if test="normalize-space(e:event_type)">
		<marc:datafield tag="711" ind1="2" ind2="">
			<marc:subfield code="a"><xsl:value-of select="e:event_type" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="normalize-space(e:publication)">
		<marc:datafield tag="730" ind1="0" ind2="">
			<marc:subfield code="a"><xsl:value-of select="e:publication" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:for-each select="e:official_url">
		<marc:datafield tag="856" ind1="4" ind2="0">
			<marc:subfield code="u"><xsl:value-of select="." /></marc:subfield>
		</marc:datafield>
	</xsl:for-each> 
	<xsl:for-each select="e:related_url/e:item">
		<marc:datafield tag="856" ind1="4" ind2="2">
			<marc:subfield code="u"><xsl:value-of select="e:url" /></marc:subfield>
		</marc:datafield>
	</xsl:for-each>
</marc:record>
</xsl:template>

<xsl:template name="tokenize">
	<xsl:param name="inputString"/>
	<xsl:param name="tokenString"/>
	<xsl:if test="string-length(normalize-space($inputString))">
		<xsl:choose>
		<xsl:when test="substring-before($inputString, $tokenString)">
			<token>
				<xsl:value-of select="normalize-space(substring-before($inputString, $tokenString))"/>
			</token>
			<xsl:call-template name="tokenize">
				<xsl:with-param name="inputString" select="normalize-space(substring-after($inputString, $tokenString))"/>
				<xsl:with-param name="tokenString" select="$tokenString"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<token>
				<xsl:value-of select="normalize-space($inputString)"/>
			</token>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>

