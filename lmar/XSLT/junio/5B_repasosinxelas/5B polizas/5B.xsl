<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>HTML</title>
            </head>
            <body>
                <h1>CLIENTES Y TIPOS DE POLIZAS</h1>
                <xsl:apply-templates select="polizas/poliza" />
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="poliza">
        <p>
            <xsl:value-of select="cliente" />
            <xsl:text> - Tipo de poliza </xsl:text>
            <xsl:value-of select="@tipo" />
        </p>
    </xsl:template>

</xsl:stylesheet>
