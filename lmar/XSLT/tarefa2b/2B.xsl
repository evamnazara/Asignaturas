<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Reclamacions</title>
            </head>
            <body>
                <h1>Reclamaciones desde 2004</h1>
                <xsl:for-each select="polizas/poliza[reclamaciones/reclamacion/ano &gt;= 2004]">
                    <p>
                        Cliente: <xsl:value-of select="cliente" />
                        <br/>
                        Fecha: 
                        <xsl:for-each select="reclamaciones/reclamacion[ano &gt;= 2004]">
                            <xsl:value-of select="ano"/>
                        </xsl:for-each>
                    </p>
                    <hr/> 
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
    
    

</xsl:stylesheet>
