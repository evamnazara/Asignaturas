<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
   
    <xsl:template match="/">
        <html>
            <head>
                <title>5A.xsl</title>
            </head>
            <body>
                
                <h2> 
                    <xsl:value-of select="grupo/@nombre"/> 
                </h2>
                <hr />
                <ul>
                    <xsl:for-each select="grupo/integrante">
                        <li> 
                            <xsl:value-of select="nombre" />
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="apellidos" />
                            - 
                            <xsl:value-of select="funcion" /> 
                        </li>
                        
                    </xsl:for-each>
                </ul>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
