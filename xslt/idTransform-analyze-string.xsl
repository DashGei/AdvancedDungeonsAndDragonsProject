<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- 2026-11-16 ebb: This identity transformation is designed to add new markup (as rs type="..." ref="#..">) around
    words in the collection files that match label values in the glossary.xml file  
    Notes:
    
   <list xml:id="..."> tells the @type value.
   
   <item xml:id="..."> tells the @ref value.
    -->
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <!-- ebb: Variables for reaching collection of XML files *except* for the glossary, and for the glossary itself.-->
    <xsl:variable name="markupCollection" as="document-node()+"
        select="collection('../markup/?select=*.xml')[base-uri() ! not(contains(., 'glossary')) and base-uri() ! not(contains(., 'teiHeader'))]"/>
    
    <xsl:variable name="glossary" as="document-node()"
        select="doc('../markup/glossary.xml')"/>
    
    <!-- ebb: We should pull in your teiHeader.xml file. This is tricky, because it's a file containing a non-namespaced element named TEI. 
    So we're going to reach for it as an element node: as="node()" rather than as="document-node()". -->
    <xsl:variable name="teiHeader" as="node()" select="doc('../markup/teiHeader.xml')//*[local-name() = 'teiHeader']"/>
    
    <xsl:template match="/">
        <xsl:for-each select="$markupCollection">
            <!-- ebb: store the currently processing filename using base-uri(). -->
            <xsl:variable name="filename" select="base-uri() ! tokenize(., '/')[last()]"/>
           <!-- ebb: Uncomment this to 'smoke test' the variable!  <xsl:value-of select="$filename"/> -->
            
            <!-- ebb: Store each output file in xmlOut so we don't overwrite the originals in markup/ -->
            <xsl:result-document method="xhtml" html-version="5" 
                omit-xml-declaration="yes" include-content-type="no"
                indent="yes" href="../xmlOut/{$filename}">
                <TEI>
                    
                        <xsl:apply-templates select="$teiHeader"/>
                    
                    <xsl:apply-templates select="$markupCollection//text"/>                    
                </TEI>
            </xsl:result-document>
            
        </xsl:for-each>
    </xsl:template>
  
</xsl:stylesheet>