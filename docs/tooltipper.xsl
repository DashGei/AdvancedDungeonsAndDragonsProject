<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="yes" 
        include-content-type="no" indent="yes"/>
    
   <!--nrg: adds the header and navbar onto the HTML file-->
   <xsl:template match="/">
       <html>
           <head>
               <title>AD&amp;D 1e Player's Handbook</title>
               <meta charset="UTF-8" />
               <meta name="viewport" content="width=device-width, initial-scale=1.0" />
               <link rel="stylesheet" type="text/css" href="style.css" />
           </head>
           <body>
                <div class="text-frame">
                    <header>
                        <h1 class="header">Guide to the Advanced Dungeons &amp; Dragons First Edition Player's
                            Handbook</h1>
                        <h2 class="header">Created by Dash Geiser, Rayne Robertson, and Nick Grundman for DIGIT 110 at PSU Behrend</h2>
                        <nav>
                            <a href="index.html">home</a> | <a href="tables.html">tables</a> | <a
                                href="class.html">CLASSES</a>
                        </nav>
                    </header>
                </div>
                <figure>
                    <div class="text-frame">
                        <div class="content-cols">
                            <xsl:apply-templates select="//body"/>
                        </div>
                    </div>
                </figure>
           </body>
       </html>
    </xsl:template> 
    
    <!--nrg: adds in the body, currently all is formatted with <p> so no extra transformation needed -->
    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!--nrg: changes XML bolding to HTML bolding-->
    <xsl:template match="emph[@rend='bold']">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>
    
    <!--nrg: almost entirely written by Mr. Gemini... will be deleted/modified, just a guide for now
             
    -->
    <xsl:variable name="glossary" select="doc('../markup/glossary.xml')"/>
    <!--nrg: this grabs all labels in the glossary, excluding ones outside of a category list (like Character Building and Combat Descriptions)-->
    <xsl:variable name="validLabels" select="$glossary//list[@xml:id ]/label"/>

    <!--nrg: i don't know what this does or why it's important-->
    <xsl:variable name="terms" select="if (exists($validLabels)) then concat('(^|\W)(', string-join($validLabels, '|'), ')($|\W)') else ''"/>
    
    <!--nrg: for all the text in the document-->
    <xsl:template match="text()">
        <xsl:choose>
            <!--nrg: test catches crashes when $terms might be empty (if none are in the text)
                     matches() checks for only text that matches, skipping past whitespace, paragraphs with no terms, etc.-->
            <xsl:when test="$terms != '' and matches(., $terms, 'i')">
                <!--nrg: checks through paragraphs that pass this test with regex for every label it found, flags="i" makes it case-insensitive-->
                <xsl:analyze-string select="." regex="{$terms}" flags="i">
                    <xsl:matching-substring>
                        <!--Gemini: Group 1 is leading space/punctuation, Group 2 is the matched term, Group 3 is trailing space/punctuation -->
                        <xsl:value-of select="regex-group(1)"/>
                        
                        <xsl:variable name="matchedWord" select="lower-case(normalize-space(regex-group(2)))"/>
                        <!--Gemini: Query $validLabels (the XML nodes), NOT $terms (the string) -->
                        <xsl:variable name="glossaryItem" select="$validLabels[lower-case(normalize-space(.)) = $matchedWord][1]/following-sibling::item[1]"/>
                        
                        <span class="{$glossaryItem/../@xml:id}" title="{normalize-space($glossaryItem/p[@n='1'])}">
                            <xsl:value-of select="regex-group(2)"/>
                        </span>
                        
                        <xsl:value-of select="regex-group(3)"/>
                    </xsl:matching-substring>
                    
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>