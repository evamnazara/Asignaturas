<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
   
    
    <xsl:template match="/">
        <html>
            <head>
                <title>HTML</title>
            </head>
            <body>
                <h1>
                    <xsl:value-of select="grupo/@nombre" />
                </h1>
                <hr></hr>
                
                <ul>
                    <xsl:apply-templates select="grupo/integrante" />
                </ul>
            </body>
        </html>
    </xsl:template>
   
    <xsl:template match="integrante">
        <li>
            <xsl:value-of select="nombre"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="apellidos"/>
            <xsl:text> - </xsl:text>
            <xsl:value-of select="funcion" />
        </li>
        
    </xsl:template>

</xsl:stylesheet>
