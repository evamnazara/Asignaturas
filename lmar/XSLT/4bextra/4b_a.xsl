<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>4precipitaciones</title>
            </head>
            <body>
                <h1>Registro de Precipitaciones</h1>
                <ul>
                    <xsl:for-each select="precipitaciones/registro">
                        <li>
                            <b> 
                                <xsl:value-of select="lugar"/> 
                            </b>
                            <xsl:text>: </xsl:text>
                            <xsl:value-of select="fecha" />
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="litros-m2"/>

                            <xsl:text>l/m2) </xsl:text>
                        </li>
                        
                    </xsl:for-each>
                </ul>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
