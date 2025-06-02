<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
   
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select="horario/@ciclo" />
                </title>
            </head>
            <body>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
