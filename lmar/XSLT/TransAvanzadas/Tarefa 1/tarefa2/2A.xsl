<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    
    <xsl:variable name="nome">
    </xsl:variable>
    <xsl:template match="/">
        <html>
            <head>
                <title>2A.xsl</title>
            </head>
            <body>
                <h1>Taboa das maquinas</h1>
                <table border="1">
                    <tr>
                        <th> Maquina </th>
                        <th> Tipo </th>
                    </tr>
                </table>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
