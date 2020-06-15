<?xml version="1.0" encoding="UTF-8"?>
<!--
EPrint to MARCXML transformation
EPrints 3.3.x compatible stylesheet, intended for use with the plugin EPrints::Plugin::Export::XSLT.
Modified to target University of Pittsburgh ETDs.

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
	xmlns:date="http://exslt.org/dates-and-times" 
	exclude-result-prefixes="xsi xsl e ept exsl date"
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

<xsl:template match="ept:template">
<marc:collection>
	<xsl:value-of select="$results" />
</marc:collection>
</xsl:template>

<xsl:template match="/e:eprints/e:eprint">
<marc:record>
	<marc:leader><xsl:text>     n</xsl:text><xsl:call-template name="decodeType"><xsl:with-param name="inputType" select="e:type" /></xsl:call-template><xsl:text>  22     7i 4500</xsl:text></marc:leader>
	<xsl:if test="e:type[text() = 'thesis_degree']">
		<xsl:if test="normalize-space(e:etd_approval_date)">
			<marc:controlfield tag="007">cr un||||||c||</marc:controlfield>
			<marc:controlfield tag="008">
				<xsl:text>      s</xsl:text><xsl:value-of select="substring-before(e:etd_approval_date, '-')" /><xsl:text>    xx      smb   00| 0|</xsl:text><xsl:call-template name="iso639convert"><xsl:with-param name="inputCode" select="e:documents/e:document[e:content/text() = 'main' and string-length(e:language) = 2][1]/e:language" /></xsl:call-template><xsl:text> d</xsl:text>
			</marc:controlfield>
		</xsl:if>
	</xsl:if>
	<xsl:if test="normalize-space(e:isbn)">
		<marc:datafield tag="020" ind1=" " ind2=" ">
			<marc:subfield code="a"><xsl:value-of select="e:isbn" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="normalize-space(e:issn)">
		<marc:datafield tag="022" ind1=" " ind2=" ">
			<marc:subfield code="a"><xsl:value-of select="e:issn" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
		<marc:datafield tag="035" ind1=" " ind2=" ">
			<marc:subfield code="a">
				<xsl:text>(PIT) </xsl:text>
				<xsl:choose>
					<xsl:when test="e:type[text() = 'thesis_degree']">
						<xsl:text>etd</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>ir</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="e:eprintid" />
			</marc:subfield>
			<xsl:if test="normalize-space(e:etdurn)">
				<marc:subfield code="z"><xsl:text>(PIT) </xsl:text><xsl:value-of select="e:etdurn" /></marc:subfield>
			</xsl:if>
		</marc:datafield>
	<xsl:if test="normalize-space(e:composition_type)">
		<marc:datafield tag="047" ind1=" " ind2=" ">
			<!-- TODO: translate to controlled vocabulary -->
			<marc:subfield code="a"><xsl:value-of select="e:composition_type" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="count(e:creators/e:item/e:name) = 1">
			<marc:datafield tag="100" ind1="1" ind2=" ">
				<marc:subfield code="a"><xsl:value-of select="e:creators/e:item/e:name/e:family" /><xsl:if test="normalize-space(e:creators/e:item/e:name/e:given)"><xsl:text>, </xsl:text><xsl:value-of select="e:creators/e:item/e:name/e:given" /></xsl:if></marc:subfield>
				<xsl:if test="normalize-space(e:creators/e:item/e:name/e:lineage)"><marc:subfield code="b"><xsl:value-of select="e:creators/e:item/e:name/e:lineage" /></marc:subfield></xsl:if>
				<xsl:if test="normalize-space(e:creators/e:item/e:name/e:honourific)"><marc:subfield code="c"><xsl:value-of select="e:creators/e:item/e:name/e:honourific" /></marc:subfield></xsl:if>
			</marc:datafield>
		</xsl:when>
		<xsl:when test="count(e:corp_creators/e:item) = 1">
			<marc:datafield tag="110" ind1="2" ind2=" ">
				<marc:subfield code="a"><xsl:value-of select="e:corp_creators/e:item" /></marc:subfield>
			</marc:datafield>
		</xsl:when>
		<xsl:when test="count(e:event_title) = 1">
			<marc:datafield tag="111" ind1="2" ind2=" ">
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
			<marc:datafield tag="100" ind1="1" ind2=" ">
				<marc:subfield code="a"><xsl:value-of select="e:creators/e:item[1]/e:name/e:family" /><xsl:if test="normalize-space(e:creators/e:item[1]/e:name/e:given)"><xsl:text>, </xsl:text><xsl:value-of select="e:creators/e:item[1]/e:name/e:given" /></xsl:if></marc:subfield>
				<xsl:if test="normalize-space(e:creators/e:item[1]/e:name/e:lineage)"><marc:subfield code="b"><xsl:value-of select="e:creators/e:item[1]/e:name/e:lineage" /></marc:subfield></xsl:if>
				<xsl:if test="normalize-space(e:creators/e:item[1]/e:name/e:honourific)"><marc:subfield code="c"><xsl:value-of select="e:creators/e:item[1]/e:name/e:honourific" /></marc:subfield></xsl:if>
			</marc:datafield>
		</xsl:when>
		<xsl:when test="count(e:corp_creators/e:item)">
			<marc:datafield tag="110" ind1="2" ind2=" ">
				<marc:subfield code="a"><xsl:value-of select="e:corp_creators/e:item[1]" /></marc:subfield>
			</marc:datafield>
		</xsl:when>
	</xsl:choose>
	<xsl:if test="normalize-space(e:title)">
		<marc:datafield tag="245" ind1="1">
			<xsl:attribute name="ind2">
				<xsl:choose>
					<xsl:when test="starts-with(e:title, 'A ')">2</xsl:when>
					<xsl:when test="starts-with(e:title, 'AN ')">3</xsl:when>
					<xsl:when test="starts-with(e:title, 'An ')">3</xsl:when>
					<xsl:when test="starts-with(e:title, 'THE ')">4</xsl:when>
					<xsl:when test="starts-with(e:title, 'The ')">4</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<marc:subfield code="a"><xsl:value-of select="e:title" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="normalize-space(e:book_title)">
		<marc:datafield tag="246" ind1="0" ind2="3">
			<marc:subfield code="a"><xsl:value-of select="e:book_title" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="normalize-space(e:publisher) or (e:type[text() = 'thesis_degree'] and normalize-space(e:etd_approval_date))">
		<marc:datafield tag="264" ind1=" " ind2="1">
			<xsl:if test="normalize-space(e:publisher)">
			<marc:subfield code="a"><xsl:value-of select="e:publisher" /></marc:subfield>
			</xsl:if>
			<xsl:if test="normalize-space(e:place_of_pub)">
				<marc:subfield code="b"><xsl:value-of select="e:place_of_pub" /></marc:subfield>
			</xsl:if>
			<xsl:choose>
			<xsl:when test="e:type[text() = 'thesis_degree'] and normalize-space(e:etd_approval_date)">
				<marc:subfield code="c"><xsl:value-of select="substring-before(e:etd_approval_date, '-')" /></marc:subfield>
			</xsl:when>
			<xsl:when test="normalize-space(e:date)">
				<marc:subfield code="c"><xsl:value-of select="e:date" /></marc:subfield>
			</xsl:when>
			</xsl:choose>
		</marc:datafield>
	</xsl:if> 
	<xsl:for-each select="e:num_pieces|e:pagerange|e:pages">
		<marc:datafield tag="300" ind1=" " ind2=" ">
			<marc:subfield code="a">
				<xsl:if test="local-name(.) = 'pagerange'">
					<xsl:text>pages </xsl:text>
				</xsl:if>
				<xsl:if test="local-name(.) = 'pages'">
					<xsl:text>1 online resource (</xsl:text>
				</xsl:if>
				<xsl:value-of select="." />
				<xsl:if test="local-name(.) = 'pages'">
					<xsl:text> pages)</xsl:text>
				</xsl:if>
			</marc:subfield>
		</marc:datafield>
	</xsl:for-each>
	<xsl:if test="count(e:num_pieces|e:pagerange|e:pages) = 0">
		<marc:datafield tag="300" ind1=" " ind2=" ">
			<marc:subfield code="a">
				<xsl:text>1 online resource (1 volume)</xsl:text>
			</marc:subfield>
		</marc:datafield>
	</xsl:if>
	<marc:datafield tag="336" ind1=" " ind2=" ">
		<marc:subfield code="a">text</marc:subfield>
		<marc:subfield code="b">txt</marc:subfield>
		<marc:subfield code="2">rdacontent</marc:subfield>
	</marc:datafield>
	<marc:datafield tag="337" ind1=" " ind2=" ">
		<marc:subfield code="a">computer</marc:subfield>
		<marc:subfield code="b">c</marc:subfield>
		<marc:subfield code="2">rdamedia</marc:subfield>
	</marc:datafield>
	<marc:datafield tag="338" ind1=" " ind2=" ">
		<marc:subfield code="a">online resource</marc:subfield>
		<marc:subfield code="b">cr</marc:subfield>
		<marc:subfield code="2">rdacarrier</marc:subfield>
	</marc:datafield>
	<xsl:if test="normalize-space(e:volume)">
		<marc:datafield tag="362" ind1="0" ind2=" ">
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
		<marc:datafield tag="490" ind1="0" ind2=" ">
			<marc:subfield code="a"><xsl:value-of select="e:series" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:for-each select="e:note">
		<marc:datafield tag="500" ind1=" " ind2=" ">
			<marc:subfield code="a"><xsl:value-of select="." /></marc:subfield>
		</marc:datafield>
	</xsl:for-each>
	<xsl:if test="count(e:divisions/e:item) = 1">
		<marc:datafield tag="500" ind1=" " ind2=" ">
			<xsl:variable name="division"><xsl:value-of select="ept:render_value('divisions')" /></xsl:variable>
			<marc:subfield code="a">
				<xsl:choose>
					<xsl:when test="string-length(normalize-space(substring-before($division, '&gt;'))) &gt; 0 and string-length(normalize-space(substring-after($division, '&gt;'))) &gt; 0">
						<xsl:text>School: </xsl:text>
						<xsl:value-of select="normalize-space(substring-before($division, '&gt;'))" />
						<xsl:text>. Program: </xsl:text>
						<xsl:value-of select="normalize-space(substring-after($division, '&gt;'))" />
						<xsl:text>.</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$division" />
					</xsl:otherwise>
				</xsl:choose>
			</marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="e:type[text() = 'thesis_degree']">
		<marc:datafield tag="502" ind1=" " ind2=" ">
			<xsl:if test="normalize-space(e:degree)">
				<marc:subfield code="b">
					<xsl:call-template name="degreeConvert">
						<xsl:with-param name="inputCode" select="e:degree" />
					</xsl:call-template>
				</marc:subfield>
			</xsl:if>
			<marc:subfield code="c">
				<xsl:text>University of Pittsburgh</xsl:text>
				<xsl:if test="not(normalize-space(e:etd_approval_date))">
					<xsl:text>.</xsl:text>
				</xsl:if>
			</marc:subfield>
			<xsl:if test="normalize-space(e:etd_approval_date)">
				<marc:subfield code="d">
					<xsl:value-of select="substring-before(e:etd_approval_date, '-')" />
					<xsl:text>.</xsl:text>
				</marc:subfield>
			</xsl:if>
		</marc:datafield>
		<marc:datafield tag="504" ind1=" " ind2=" ">
			<marc:subfield code="a">
				<xsl:text>Includes bibliographic references</xsl:text>
			</marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="normalize-space(e:abstract)">
		<marc:datafield tag="520" ind1="3" ind2=" ">
			<marc:subfield code="a"><xsl:value-of select="e:abstract" /></marc:subfield>
		</marc:datafield>
	</xsl:if> 
	<xsl:if test="normalize-space(e:output_media)">
		<marc:datafield tag="533" ind1=" " ind2=" ">
			<marc:subfield code="a"><xsl:value-of select="e:output_media" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="count(e:subjects/e:item)">
		<xsl:for-each select="e:subjects/e:item">
			<marc:datafield tag="650" ind1=" " ind2="4">
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
		<marc:datafield tag="653" ind1=" " ind2=" ">
			<xsl:for-each select="exsl:node-set($keywordList)/token">
				<marc:subfield code="a"><xsl:value-of select="." /></marc:subfield>
			</xsl:for-each>
		</marc:datafield>
	</xsl:if>
	<marc:datafield tag="655" ind1=" " ind2="7">
		<marc:subfield code="a">Academic theses.</marc:subfield>
		<marc:subfield code="2">lcgft</marc:subfield>
	</marc:datafield>
	<xsl:choose>
		<xsl:when test="count(e:creators/e:item/e:name) = 1 or count(e:corp_creators/e:item) = 1 or count(e:event_title) = 1" />
		<xsl:when test="count(e:creators/e:item/e:name)">
			<xsl:for-each select="e:creators/e:item/e:name">
				<xsl:if test="position()>1">
					<marc:datafield tag="700" ind1="1" ind2=" ">
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
					<marc:datafield tag="710" ind1="2" ind2=" ">
						<marc:subfield code="a"><xsl:value-of select="." /></marc:subfield>
					</marc:datafield>
	</xsl:if>
			</xsl:for-each>
		</xsl:when>
	</xsl:choose>
	<xsl:for-each select="e:editors|e:producers|e:conductors|e:lyracists|e:exhibitors">
		<xsl:for-each select="e:item/e:name">
			<marc:datafield tag="700" ind1="1" ind2=" ">
				<marc:subfield code="a"><xsl:value-of select="e:family" /><xsl:if test="normalize-space(e:given)"><xsl:text>, </xsl:text><xsl:value-of select="e:given" /></xsl:if></marc:subfield>
				<xsl:if test="normalize-space(e:lineage)"><marc:subfield code="b"><xsl:value-of select="e:lineage" /></marc:subfield></xsl:if>
				<xsl:if test="normalize-space(e:honourific)"><marc:subfield code="c"><xsl:value-of select="e:honourific" /></marc:subfield></xsl:if>
			</marc:datafield>
		</xsl:for-each> 
	</xsl:for-each> 
	<xsl:if test="normalize-space(e:institution)">
		<marc:datafield tag="710" ind1="2" ind2=" ">
			<marc:subfield code="a"><xsl:value-of select="e:institution" /></marc:subfield>
		</marc:datafield>
	</xsl:if> 
	<xsl:if test="normalize-space(e:event_type)">
		<marc:datafield tag="711" ind1="2" ind2=" ">
			<marc:subfield code="a"><xsl:value-of select="e:event_type" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:if test="normalize-space(e:publication)">
		<marc:datafield tag="730" ind1="0" ind2=" ">
			<marc:subfield code="a"><xsl:value-of select="e:publication" /></marc:subfield>
		</marc:datafield>
	</xsl:if>
	<xsl:for-each select="e:official_url">
		<marc:datafield tag="856" ind1="4" ind2="0">
			<marc:subfield code="u"><xsl:value-of select="." /></marc:subfield>
		</marc:datafield>
	</xsl:for-each> 
	<marc:datafield tag="856" ind1="4" ind2="0">
		<marc:subfield code="u">
			<xsl:choose>
				<xsl:when test="contains(@id, '/id/eprint/')">
					<xsl:value-of select="substring-before(@id, '/id/eprint/')" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring-after(@id, '/id/eprint/')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@id" />
				</xsl:otherwise>
			</xsl:choose>
		</marc:subfield>
		<marc:subfield code="z">
			<xsl:choose>
				<xsl:when test="e:etd_access_restriction[text() = 'immediately']">
					<xsl:text>Unrestricted Access.</xsl:text>
				</xsl:when>
				<xsl:when test="number(substring-before(e:etd_access_restriction, '_year')) &gt; 0">
					<xsl:variable name="embargo"><xsl:text>P</xsl:text><xsl:value-of select="number(substring-before(e:etd_access_restriction, '_year'))" /><xsl:text>Y</xsl:text></xsl:variable>
					<xsl:text>Access restricted to University of Pittsburgh users until </xsl:text><xsl:value-of select="date:add(e:etd_approval_date, $embargo)" /><xsl:text>, then Available electronically via the Internet.</xsl:text>
				</xsl:when>
				<xsl:when test="not(normalize-space(e:etd_access_restriction))">
					<xsl:text>Access restricted to University of Pittsburgh users.</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Unrestricted Access.</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</marc:subfield>
	</marc:datafield>
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

<xsl:template name="decodeType">
	<xsl:param name="inputType" />
	<xsl:variable name="typeList">
		<type><eprint>article</eprint><marc>ab</marc></type>
		<type><eprint>audio</eprint><marc> m</marc></type>
		<type><eprint>book_section</eprint><marc>aa</marc></type>
		<type><eprint>book</eprint><marc></marc>am</type>
		<type><eprint>conference_item</eprint><marc>am</marc></type>
		<type><eprint>conferenceitem</eprint><marc>am</marc></type>
		<type><eprint>dataset</eprint><marc>mc</marc></type>
		<type><eprint>exhibition</eprint><marc>km</marc></type>
		<type><eprint>experiment</eprint><marc>mm</marc></type>
		<type><eprint>image</eprint><marc>mm</marc></type>
		<type><eprint>monograph</eprint><marc>am</marc></type>
		<type><eprint>other</eprint><marc>mm</marc></type>
		<type><eprint>performance</eprint><marc>mm</marc></type>
		<type><eprint>thesis_degree</eprint><marc>tm</marc></type>
		<type><eprint>thesis</eprint><marc>tm</marc></type>
		<type><eprint>video</eprint><marc>gm</marc></type>
	</xsl:variable>

	<xsl:choose>
		<xsl:when test="normalize-space(exsl:node-set($typeList)/type[eprint/text() = $inputType]/marc)">
			<xsl:value-of select="exsl:node-set($typeList)/type[eprint/text() = $inputType]/marc" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>  </xsl:text>
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>

<xsl:template name="degreeConvert">
	<xsl:param name="inputCode" />
	<xsl:variable name="codeList">
		<degree><code>BA</code><abbr>B.A.</abbr></degree>
		<degree><code>BPhil</code><abbr>B. Phil.</abbr></degree>
		<degree><code>BS</code><abbr>B.S.</abbr></degree>
		<degree><code>BSE</code><abbr>B.S.E.</abbr></degree>
		<degree><code>BSBA</code><abbr>B.S.B.A.</abbr></degree>
		<degree><code>BSN</code><abbr>B.S.N.</abbr></degree>
		<degree><code>DMD</code><abbr>D.M.D.</abbr></degree>
		<degree><code>DrPH</code><abbr>Dr. P.H.</abbr></degree>
		<degree><code>EdD</code><abbr>Ed. D.</abbr></degree>
		<degree><code>MA</code><abbr>M.A.</abbr></degree>
		<degree><code>MAT</code><abbr>M.A.T.</abbr></degree>
		<degree><code>MBA</code><abbr>M.B.A.</abbr></degree>
		<degree><code>MD</code><abbr>M.D.</abbr></degree>
		<degree><code>MDS</code><abbr>M.D.S.</abbr></degree>
		<degree><code>MEd</code><abbr>M. Ed.</abbr></degree>
		<degree><code>MFA</code><abbr>M.F.A.</abbr></degree>
		<degree><code>MHA</code><abbr>M.H.A.</abbr></degree>
		<degree><code>MHPE</code><abbr>M.H.P.E.</abbr></degree>
		<degree><code>MIB</code><abbr>M.I.B.</abbr></degree>
		<degree><code>MID</code><abbr>M.I.D.</abbr></degree>
		<degree><code>MLIS</code><abbr>M.L.I.S.</abbr></degree>
		<degree><code>MOT</code><abbr>M.O.T.</abbr></degree>
		<degree><code>MPA</code><abbr>M.P.A.</abbr></degree>
		<degree><code>MPH</code><abbr>M.P.H.</abbr></degree>
		<degree><code>MPIA</code><abbr>M.P.I.A.</abbr></degree>
		<degree><code>MPPM</code><abbr>M.P.P.M.</abbr></degree>
		<degree><code>MPT</code><abbr>M.P.T.</abbr></degree>
		<degree><code>MS</code><abbr>M.S.</abbr></degree>
		<degree><code>MSBeng</code><abbr>M.S. Beng.</abbr></degree>
		<degree><code>MSCE</code><abbr>M.S.C.E.</abbr></degree>
		<degree><code>MSChE</code><abbr>M.S. Ch. E.</abbr></degree>
		<degree><code>MSCoE</code><abbr>M.S. Co. E.</abbr></degree>
		<degree><code>MSEE</code><abbr>M.S.E.E.</abbr></degree>
		<degree><code>MSIE</code><abbr>M.S.I.E.</abbr></degree>
		<degree><code>MSIS</code><abbr>M.S.I.S.</abbr></degree>
		<degree><code>MSL</code><abbr>M.S.L.</abbr></degree>
		<degree><code>MSME</code><abbr>M.S.M.E.</abbr></degree>
		<degree><code>MSMSE</code><abbr>M.S.M.S.E</abbr></degree>
		<degree><code>MSMetE</code><abbr>M.S. Met. E.</abbr></degree>
		<degree><code>MSMfSE</code><abbr>M.S. Mf. S.E.</abbr></degree>
		<degree><code>MSN</code><abbr>M.S.N.</abbr></degree>
		<degree><code>MSPE</code><abbr>M.S.P.E.</abbr></degree>
		<degree><code>MST</code><abbr>M.S.T.</abbr></degree>
		<degree><code>MSW</code><abbr>M.S.W.</abbr></degree>
		<degree><code>PhD</code><abbr>Ph. D.</abbr></degree>
		<degree><code>PharmD</code><abbr>Pharm. D.</abbr></degree>
		<degree><code>PsyD</code><abbr>Psy. D.</abbr></degree>
		<degree><code>SJD</code><abbr>S.J.D.</abbr></degree>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="normalize-space(exsl:node-set($codeList)/degree[code/text() = $inputCode]/abbr)">
			<xsl:value-of select="exsl:node-set($codeList)/degree[code/text() = $inputCode]/abbr" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$inputCode" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="iso639convert">
	<xsl:param name="inputCode" />
	<xsl:variable name="iso639list">
		<iso639><dash2>aar</dash2><dash1>aa</dash1></iso639>
		<iso639><dash2>abk</dash2><dash1>ab</dash1></iso639>
		<iso639><dash2>ave</dash2><dash1>ae</dash1></iso639>
		<iso639><dash2>afr</dash2><dash1>af</dash1></iso639>
		<iso639><dash2>aka</dash2><dash1>ak</dash1></iso639>
		<iso639><dash2>amh</dash2><dash1>am</dash1></iso639>
		<iso639><dash2>arg</dash2><dash1>an</dash1></iso639>
		<iso639><dash2>ara</dash2><dash1>ar</dash1></iso639>
		<iso639><dash2>asm</dash2><dash1>as</dash1></iso639>
		<iso639><dash2>ava</dash2><dash1>av</dash1></iso639>
		<iso639><dash2>aym</dash2><dash1>ay</dash1></iso639>
		<iso639><dash2>aze</dash2><dash1>az</dash1></iso639>
		<iso639><dash2>bak</dash2><dash1>ba</dash1></iso639>
		<iso639><dash2>bel</dash2><dash1>be</dash1></iso639>
		<iso639><dash2>bul</dash2><dash1>bg</dash1></iso639>
		<iso639><dash2>bih</dash2><dash1>bh</dash1></iso639>
		<iso639><dash2>bis</dash2><dash1>bi</dash1></iso639>
		<iso639><dash2>bam</dash2><dash1>bm</dash1></iso639>
		<iso639><dash2>ben</dash2><dash1>bn</dash1></iso639>
		<iso639><dash2>tib</dash2><dash1>bo</dash1></iso639>
		<iso639><dash2>bre</dash2><dash1>br</dash1></iso639>
		<iso639><dash2>bos</dash2><dash1>bs</dash1></iso639>
		<iso639><dash2>cat</dash2><dash1>ca</dash1></iso639>
		<iso639><dash2>che</dash2><dash1>ce</dash1></iso639>
		<iso639><dash2>cha</dash2><dash1>ch</dash1></iso639>
		<iso639><dash2>cos</dash2><dash1>co</dash1></iso639>
		<iso639><dash2>cre</dash2><dash1>cr</dash1></iso639>
		<iso639><dash2>cze</dash2><dash1>cs</dash1></iso639>
		<iso639><dash2>chu</dash2><dash1>cu</dash1></iso639>
		<iso639><dash2>chv</dash2><dash1>cv</dash1></iso639>
		<iso639><dash2>wel</dash2><dash1>cy</dash1></iso639>
		<iso639><dash2>dan</dash2><dash1>da</dash1></iso639>
		<iso639><dash2>ger</dash2><dash1>de</dash1></iso639>
		<iso639><dash2>div</dash2><dash1>dv</dash1></iso639>
		<iso639><dash2>dzo</dash2><dash1>dz</dash1></iso639>
		<iso639><dash2>ewe</dash2><dash1>ee</dash1></iso639>
		<iso639><dash2>gre</dash2><dash1>el</dash1></iso639>
		<iso639><dash2>eng</dash2><dash1>en</dash1></iso639>
		<iso639><dash2>epo</dash2><dash1>eo</dash1></iso639>
		<iso639><dash2>spa</dash2><dash1>es</dash1></iso639>
		<iso639><dash2>est</dash2><dash1>et</dash1></iso639>
		<iso639><dash2>baq</dash2><dash1>eu</dash1></iso639>
		<iso639><dash2>per</dash2><dash1>fa</dash1></iso639>
		<iso639><dash2>ful</dash2><dash1>ff</dash1></iso639>
		<iso639><dash2>fin</dash2><dash1>fi</dash1></iso639>
		<iso639><dash2>fij</dash2><dash1>fj</dash1></iso639>
		<iso639><dash2>fao</dash2><dash1>fo</dash1></iso639>
		<iso639><dash2>fre</dash2><dash1>fr</dash1></iso639>
		<iso639><dash2>fry</dash2><dash1>fy</dash1></iso639>
		<iso639><dash2>gle</dash2><dash1>ga</dash1></iso639>
		<iso639><dash2>gla</dash2><dash1>gd</dash1></iso639>
		<iso639><dash2>glg</dash2><dash1>gl</dash1></iso639>
		<iso639><dash2>grn</dash2><dash1>gn</dash1></iso639>
		<iso639><dash2>guj</dash2><dash1>gu</dash1></iso639>
		<iso639><dash2>glv</dash2><dash1>gv</dash1></iso639>
		<iso639><dash2>hau</dash2><dash1>ha</dash1></iso639>
		<iso639><dash2>heb</dash2><dash1>he</dash1></iso639>
		<iso639><dash2>hin</dash2><dash1>hi</dash1></iso639>
		<iso639><dash2>hmo</dash2><dash1>ho</dash1></iso639>
		<iso639><dash2>hrv</dash2><dash1>hr</dash1></iso639>
		<iso639><dash2>hat</dash2><dash1>ht</dash1></iso639>
		<iso639><dash2>hun</dash2><dash1>hu</dash1></iso639>
		<iso639><dash2>arm</dash2><dash1>hy</dash1></iso639>
		<iso639><dash2>her</dash2><dash1>hz</dash1></iso639>
		<iso639><dash2>ina</dash2><dash1>ia</dash1></iso639>
		<iso639><dash2>ind</dash2><dash1>id</dash1></iso639>
		<iso639><dash2>ile</dash2><dash1>ie</dash1></iso639>
		<iso639><dash2>ibo</dash2><dash1>ig</dash1></iso639>
		<iso639><dash2>iii</dash2><dash1>ii</dash1></iso639>
		<iso639><dash2>ipk</dash2><dash1>ik</dash1></iso639>
		<iso639><dash2>ido</dash2><dash1>io</dash1></iso639>
		<iso639><dash2>ice</dash2><dash1>is</dash1></iso639>
		<iso639><dash2>ita</dash2><dash1>it</dash1></iso639>
		<iso639><dash2>iku</dash2><dash1>iu</dash1></iso639>
		<iso639><dash2>jpn</dash2><dash1>ja</dash1></iso639>
		<iso639><dash2>jav</dash2><dash1>jv</dash1></iso639>
		<iso639><dash2>geo</dash2><dash1>ka</dash1></iso639>
		<iso639><dash2>kon</dash2><dash1>kg</dash1></iso639>
		<iso639><dash2>kik</dash2><dash1>ki</dash1></iso639>
		<iso639><dash2>kua</dash2><dash1>kj</dash1></iso639>
		<iso639><dash2>kaz</dash2><dash1>kk</dash1></iso639>
		<iso639><dash2>kal</dash2><dash1>kl</dash1></iso639>
		<iso639><dash2>khm</dash2><dash1>km</dash1></iso639>
		<iso639><dash2>kan</dash2><dash1>kn</dash1></iso639>
		<iso639><dash2>kor</dash2><dash1>ko</dash1></iso639>
		<iso639><dash2>kau</dash2><dash1>kr</dash1></iso639>
		<iso639><dash2>kas</dash2><dash1>ks</dash1></iso639>
		<iso639><dash2>kur</dash2><dash1>ku</dash1></iso639>
		<iso639><dash2>kom</dash2><dash1>kv</dash1></iso639>
		<iso639><dash2>cor</dash2><dash1>kw</dash1></iso639>
		<iso639><dash2>kir</dash2><dash1>ky</dash1></iso639>
		<iso639><dash2>lat</dash2><dash1>la</dash1></iso639>
		<iso639><dash2>ltz</dash2><dash1>lb</dash1></iso639>
		<iso639><dash2>lug</dash2><dash1>lg</dash1></iso639>
		<iso639><dash2>lim</dash2><dash1>li</dash1></iso639>
		<iso639><dash2>lin</dash2><dash1>ln</dash1></iso639>
		<iso639><dash2>lao</dash2><dash1>lo</dash1></iso639>
		<iso639><dash2>lit</dash2><dash1>lt</dash1></iso639>
		<iso639><dash2>lub</dash2><dash1>lu</dash1></iso639>
		<iso639><dash2>lav</dash2><dash1>lv</dash1></iso639>
		<iso639><dash2>mlg</dash2><dash1>mg</dash1></iso639>
		<iso639><dash2>mah</dash2><dash1>mh</dash1></iso639>
		<iso639><dash2>mao</dash2><dash1>mi</dash1></iso639>
		<iso639><dash2>mac</dash2><dash1>mk</dash1></iso639>
		<iso639><dash2>mal</dash2><dash1>ml</dash1></iso639>
		<iso639><dash2>mon</dash2><dash1>mn</dash1></iso639>
		<iso639><dash2>mar</dash2><dash1>mr</dash1></iso639>
		<iso639><dash2>may</dash2><dash1>ms</dash1></iso639>
		<iso639><dash2>mlt</dash2><dash1>mt</dash1></iso639>
		<iso639><dash2>bur</dash2><dash1>my</dash1></iso639>
		<iso639><dash2>nau</dash2><dash1>na</dash1></iso639>
		<iso639><dash2>nob</dash2><dash1>nb</dash1></iso639>
		<iso639><dash2>nde</dash2><dash1>nd</dash1></iso639>
		<iso639><dash2>nep</dash2><dash1>ne</dash1></iso639>
		<iso639><dash2>ndo</dash2><dash1>ng</dash1></iso639>
		<iso639><dash2>dut</dash2><dash1>nl</dash1></iso639>
		<iso639><dash2>nno</dash2><dash1>nn</dash1></iso639>
		<iso639><dash2>nor</dash2><dash1>no</dash1></iso639>
		<iso639><dash2>nbl</dash2><dash1>nr</dash1></iso639>
		<iso639><dash2>nav</dash2><dash1>nv</dash1></iso639>
		<iso639><dash2>nya</dash2><dash1>ny</dash1></iso639>
		<iso639><dash2>oci</dash2><dash1>oc</dash1></iso639>
		<iso639><dash2>oji</dash2><dash1>oj</dash1></iso639>
		<iso639><dash2>orm</dash2><dash1>om</dash1></iso639>
		<iso639><dash2>ori</dash2><dash1>or</dash1></iso639>
		<iso639><dash2>oss</dash2><dash1>os</dash1></iso639>
		<iso639><dash2>pan</dash2><dash1>pa</dash1></iso639>
		<iso639><dash2>pli</dash2><dash1>pi</dash1></iso639>
		<iso639><dash2>pol</dash2><dash1>pl</dash1></iso639>
		<iso639><dash2>pus</dash2><dash1>ps</dash1></iso639>
		<iso639><dash2>por</dash2><dash1>pt</dash1></iso639>
		<iso639><dash2>que</dash2><dash1>qu</dash1></iso639>
		<iso639><dash2>roh</dash2><dash1>rm</dash1></iso639>
		<iso639><dash2>run</dash2><dash1>rn</dash1></iso639>
		<iso639><dash2>rum</dash2><dash1>ro</dash1></iso639>
		<iso639><dash2>rus</dash2><dash1>ru</dash1></iso639>
		<iso639><dash2>kin</dash2><dash1>rw</dash1></iso639>
		<iso639><dash2>san</dash2><dash1>sa</dash1></iso639>
		<iso639><dash2>srd</dash2><dash1>sc</dash1></iso639>
		<iso639><dash2>snd</dash2><dash1>sd</dash1></iso639>
		<iso639><dash2>sme</dash2><dash1>se</dash1></iso639>
		<iso639><dash2>sag</dash2><dash1>sg</dash1></iso639>
		<iso639><dash2>sin</dash2><dash1>si</dash1></iso639>
		<iso639><dash2>slo</dash2><dash1>sk</dash1></iso639>
		<iso639><dash2>slv</dash2><dash1>sl</dash1></iso639>
		<iso639><dash2>smo</dash2><dash1>sm</dash1></iso639>
		<iso639><dash2>sna</dash2><dash1>sn</dash1></iso639>
		<iso639><dash2>som</dash2><dash1>so</dash1></iso639>
		<iso639><dash2>alb</dash2><dash1>sq</dash1></iso639>
		<iso639><dash2>srp</dash2><dash1>sr</dash1></iso639>
		<iso639><dash2>ssw</dash2><dash1>ss</dash1></iso639>
		<iso639><dash2>sot</dash2><dash1>st</dash1></iso639>
		<iso639><dash2>sun</dash2><dash1>su</dash1></iso639>
		<iso639><dash2>swe</dash2><dash1>sv</dash1></iso639>
		<iso639><dash2>swa</dash2><dash1>sw</dash1></iso639>
		<iso639><dash2>tam</dash2><dash1>ta</dash1></iso639>
		<iso639><dash2>tel</dash2><dash1>te</dash1></iso639>
		<iso639><dash2>tgk</dash2><dash1>tg</dash1></iso639>
		<iso639><dash2>tha</dash2><dash1>th</dash1></iso639>
		<iso639><dash2>tir</dash2><dash1>ti</dash1></iso639>
		<iso639><dash2>tuk</dash2><dash1>tk</dash1></iso639>
		<iso639><dash2>tgl</dash2><dash1>tl</dash1></iso639>
		<iso639><dash2>tsn</dash2><dash1>tn</dash1></iso639>
		<iso639><dash2>ton</dash2><dash1>to</dash1></iso639>
		<iso639><dash2>tur</dash2><dash1>tr</dash1></iso639>
		<iso639><dash2>tso</dash2><dash1>ts</dash1></iso639>
		<iso639><dash2>tat</dash2><dash1>tt</dash1></iso639>
		<iso639><dash2>twi</dash2><dash1>tw</dash1></iso639>
		<iso639><dash2>tah</dash2><dash1>ty</dash1></iso639>
		<iso639><dash2>uig</dash2><dash1>ug</dash1></iso639>
		<iso639><dash2>ukr</dash2><dash1>uk</dash1></iso639>
		<iso639><dash2>urd</dash2><dash1>ur</dash1></iso639>
		<iso639><dash2>uzb</dash2><dash1>uz</dash1></iso639>
		<iso639><dash2>ven</dash2><dash1>ve</dash1></iso639>
		<iso639><dash2>vie</dash2><dash1>vi</dash1></iso639>
		<iso639><dash2>vol</dash2><dash1>vo</dash1></iso639>
		<iso639><dash2>wln</dash2><dash1>wa</dash1></iso639>
		<iso639><dash2>wol</dash2><dash1>wo</dash1></iso639>
		<iso639><dash2>xho</dash2><dash1>xh</dash1></iso639>
		<iso639><dash2>yid</dash2><dash1>yi</dash1></iso639>
		<iso639><dash2>yor</dash2><dash1>yo</dash1></iso639>
		<iso639><dash2>zha</dash2><dash1>za</dash1></iso639>
		<iso639><dash2>chi</dash2><dash1>zh</dash1></iso639>
		<iso639><dash2>zul</dash2><dash1>zu</dash1></iso639>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="normalize-space(exsl:node-set($iso639list)/iso639[dash1/text() = $inputCode]/dash2)">
			<xsl:value-of select="exsl:node-set($iso639list)/iso639[dash1/text() = $inputCode]/dash2" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>   </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
