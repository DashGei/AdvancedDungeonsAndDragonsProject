<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="yes" 
        include-content-type="no" indent="yes"/>
    
   <!--nrg: adds the header and navbar onto the HTML file-->
    <!-- 2026-11-16 ebb: You didn't indicate what files are supposed to be processed by the tooltipper: You'd need to set up a collection variable to 
    have this run over all the files in the collection. Currently it runs over whatever document is indicated in the oXygen processing window,
    and it only works for glossary.xml. 
    
    We're going to do that work in a different XSLT file as an identity transformation to add new markup to your XML collection files.
    This will simplify your project processing and effect a good separation of concerns. 
    The processing here can be better applied to adding new markup
    to the project. -->
   <xsl:template match="/">
       <html>
           <head>
               <title>AD&amp;D 1e Player's Handbook</title>
               <meta charset="UTF-8" />
               <meta name="viewport" content="width=device-width, initial-scale=1.0" />
               <link rel="stylesheet" type="text/css" href="style.css" />
               <script type="text/javascript" src="script.js" defer="defer"/>
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
    
    <xsl:variable name="glossary" as="document-node()"
        select="doc('../markup/glossary.xml')"/>
    
    <!-- ebb: Find the gloss item elements -->
    <xsl:variable name="glossItems" as="element()+" select="$glossary//item/list/item"/>
      
    <xsl:template match="rs">
        <!--nrg: This is the HTML structure of a tooltip-->
        <span class="{concat(current()/@type, ' tooltip-trigger')}">
            <xsl:variable name="matchingGloss" as="element()+" select="$glossary//item/list/item[@xml:id = substring-after(current()/@ref, '#')]"/>
            <xsl:apply-templates/> <!--nrg: matching string, text that contains the tooltip-->
            <span class="tt-frame">
                <span class="tt-cont">
                    <xsl:value-of select="$matchingGloss/p[@ana = '#tto']"/><br/> <!--nrg: content of the tooltip-->
                    <span class="tt-desc">
                    Category: <xsl:value-of select="current()/@type"/> | <!--nrg: category description, should find in glossary later-->
                    Page: <xsl:value-of select="$matchingGloss/@n"/> (+1 in PDF) | <!--nrg: page number(s) of tooltip text-->
                    Coded by: <xsl:value-of select="$matchingGloss/@resp"/><!--nrg: encoder info, should find in glossary later-->
                    </span>
                    <button type="button" class="collapseButton">Open Handbook</button>
                    <iframe class="collapsible" src="{concat('content/players-handbook.pdf', '#page=', $matchingGloss/@n + 1)}"/>
                </span>
            </span>
        </span>

    </xsl:template>
    
</xsl:stylesheet>