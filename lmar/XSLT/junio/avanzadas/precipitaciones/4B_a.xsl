<?xml version="1.0"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Precipitaciones</title>
            </head>
            <body>
                <h1>Registro de precipitaciones</h1>
                <ul>
                    <xsl:apply-templates select="//registro" />
                </ul>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="registro">
        <li>
           <b> <xsl:value-of select="lugar"/>: </b> 
           <xsl:value-of select="fecha"/> 
           ( <xsl:value-of select="litros-m2"/>
           )
        </li>
    </xsl:template>
    
    

</xsl:stylesheet>
