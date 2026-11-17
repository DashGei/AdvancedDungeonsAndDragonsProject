<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- 2026-11-16 ebb: This identity transformation is designed to add new markup 
        as rs type="..." ref="#.."> around
    words/names in the collection files that match label values in the glossary.xml file  
    XPath processing notes
    
   <item xml:id="..."> tells the @ref value.
   <label> that is first preceding-sibling of an item is associated with that distinct identifier.
   <list that is immediate parent holds @type attribute defining the @type value. 
    -->
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <!-- ebb: Variables for reaching collection of XML files *except* for the glossary, and for the glossary itself.-->
    <xsl:variable name="markupCollection" as="document-node()+"
        select="collection('../markup/?select=*.xml')[base-uri() ! not(contains(., 'glossary')) and base-uri() ! not(contains(., 'teiHeader'))]"/>
    
    <xsl:variable name="glossary" as="document-node()"
        select="doc('../markup/glossary.xml')"/>
    
    <!-- ebb: Find the gloss item elements -->
    <xsl:variable name="glossItems" as="element()+" select="$glossary//item/list/item"/>
    
    <xsl:variable name="glossLabels" as="xs:string+" select="$glossary//item/list/label ! normalize-space() => distinct-values()"/>
    <!-- ebb: Okay, turns out we'd better concatenate these into a single ball of string. We'll string-join them with a character
    we don't expect to see in the markup documents. -->
    <xsl:variable name="glossLabelBallofString" as="xs:string" select="string-join($glossLabels, '|')"/>
    
    <!-- ebb: gloss item xml:ids: normalize-space() to remove any additonal spaces to ease matching -->
    <xsl:variable name="glossIDs" as="xs:string+" select="$glossItems/@xml:id ! normalize-space()"/>

    <!-- ebb: While we're doing these Identity Transforms, we should pull in your teiHeader.xml file. 
        This is tricky, because it's a file with a TEI element that isn't really a TEI document. 
    So we're going to reach for it as an element node: as="node()" rather than as="document-node()".
    I made this work by setting the TEI namespace on the teiHeader element in the XML file.
    -->
    <xsl:variable name="teiHeader" as="node()" select="doc('../markup/teiHeader.xml')//*[local-name() = 'teiHeader']"/>
    
    <!--ebb: Document node processing helps us to configure our many-to-many identity transformation: -->
    <xsl:template match="/">
        <xsl:for-each select="$markupCollection">
            <!-- ebb: store the currently processing filename using base-uri(). -->
            <xsl:variable name="filename" select="base-uri() ! tokenize(., '/')[last()]"/>
           <!-- ebb: Uncomment this to 'smoke test' the variable!  <xsl:value-of select="$filename"/> -->
            
            <!-- ebb: Store each output file in xmlOut so we don't overwrite the originals in markup/ -->
            <xsl:result-document method="xhtml" html-version="5" 
                omit-xml-declaration="yes" include-content-type="no"
                indent="yes" href="../xmlOut/{$filename}">
              <!-- ebb: Put in the Schema lines from your source files.-->
                <xsl:processing-instruction name="xml-model">
            <xsl:text>href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:text>
                 </xsl:processing-instruction>
                <xsl:processing-instruction name="xml-model">
            <xsl:text>href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:text>
                 </xsl:processing-instruction>
                <TEI>
                        <xsl:copy-of select="$teiHeader"/>
                        <xsl:apply-templates select="descendant::text"/>                    
                </TEI>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="text//*[not(self::* = rs)]/text()[matches(., '\S+')]">
        <!--ebb: This template matches any (wildcard) element's text nodes nested within the TEI <text> element, 
            so long as its text() node matches at least one or more NON-SPACE characters. 
          We'll use an xsl:element constructor and make a copy of its attributes to reset its element name and attributes
        -->
   
            <xsl:variable name="currentNode" as="text()" select="current()"/>
            <!--ebb: Store the current text node in a variable to call when we shift contexts in xsl:for-each below. -->
    
     <xsl:choose> 
         <xsl:when test="matches($currentNode, $glossLabelBallofString, 'i')">   
        <xsl:analyze-string select="current()" regex="{$glossLabelBallofString}" flags="i">
                <xsl:matching-substring>
                    <xsl:variable name="matchingGloss" as="element()?" 
                        select="$glossary//label[(normalize-space() ! lower-case(.) = regex-group(0) ! lower-case(.))]"/>
                    <!-- ebb: Our regex analyze-string matching substring is just regex-group(0) . Lower-case() both sides to ensure matches all round -->
                    <xsl:comment>Matching string: <xsl:value-of select="regex-group(0)"/></xsl:comment>
                    <rs type="{$matchingGloss/parent::list/@xml:id}" 
                        ref="#{$matchingGloss//following-sibling::item[1]/@xml:id}">
                        <xsl:value-of select="."/>
                    </rs>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                    <!-- ebb: We can't use xsl:apply-templates when we've template matched on text nodes. 
                        (There can't be any templates to match on these "leaf" text nodes.)
                    So all of this is returning xsl:value-of.-->
                </xsl:non-matching-substring>
            </xsl:analyze-string>
            </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="."/>
        </xsl:otherwise>
     </xsl:choose>
    </xsl:template>
    

</xsl:stylesheet>