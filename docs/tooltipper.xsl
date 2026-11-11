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
    
    <!--nrg: almost entirely written by Mr. Gemini... will be deleted, just a guide for now
        this is pretty inadequate as well, because the regex is manually coded, which gets rid of the whole point of this
    -->
    <xsl:variable name="glossary" select="doc('../markup/glossary.xml')"/>
    
    <xsl:template match="text()">
        <xsl:analyze-string select="." regex="(Strength|Intelligence|Wisdom|Charisma|Constitution)" flags="i">

            <xsl:matching-substring>
                <xsl:variable name="termUpper" select="upper-case(.)"/>
                <xsl:variable name="statID" select="substring($termUpper, 1, 3)"/>
                
                <xsl:variable name="glossaryItem" select="$glossary//item[@xml:id = $statID]"/>
                
                <span class="{$glossaryItem/../@xml:id}">
                    <xsl:attribute name="title">
                        <xsl:value-of select="normalize-space($glossaryItem/p[@ana='#TTo'])"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </span>
            </xsl:matching-substring>

            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
            
        </xsl:analyze-string>
    </xsl:template>
    
    
</xsl:stylesheet>