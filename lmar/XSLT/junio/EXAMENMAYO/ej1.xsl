<?xml version="1.0"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Alojamientos</title>
            </head>
            <body>
                <h1>Hoteles</h1>
                <xsl:apply-templates select="alojamientos/hoteles/hotel">
                    <xsl:sort select="@estrellas" order="descending"/>
                    <xsl:sort select="nombre" order="descending"/>
                </xsl:apply-templates>
                
            </body>
        </html>
    </xsl:template>
    <xsl:template match="hotel">
        <p>
            <a href="#1"> 
                <xsl:value-of select="nombre" />
                (
                <xsl:value-of select="@estrellas" /> estrellas)
            </a>
        </p>
        <hr/>
        
    </xsl:template>
</xsl:stylesheet>
