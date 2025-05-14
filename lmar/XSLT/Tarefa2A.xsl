<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="text"/>
    <xsl:template match="cliente/@cod">
        <html>
            <head>
                <title>Tarefa2A.xsl</title>
            </head>
            <body>
                <xsl:element name= "cliente/@cod">
                    <xsl:attribute name="nome">
                        <xsl:value-of select="text()" />
                    </xsl:attribute>
                    
                </xsl:element>
                
                <xsl:element></xsl:element>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
