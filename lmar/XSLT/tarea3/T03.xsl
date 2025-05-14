<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>T03</title>
            </head>
            <body>
                <h1>Taboa das maquinas</h1>
                
                <table border= "1">
                    <tr>
                        <th>Máquina</th>
                        <th>Procesador</th>
                        <th>Memoria </th>
                        <th>Discos</th>
                    </tr>
                    <!----> 
                    <xsl:apply-templates select="equipos/máquina"/>
                    <xsl:template match="máquina">
                        <tr>
                            <td>
                                <xsl:value-of select="/máquina/@nome" />
                            </td>
                            <td>
                                <xsl:value-of select="hardware/procesador/@marca" />
                                <xsl:text> - </xsl:text>
                                <xsl:value-of select="hardware/procesador/text()" />
                            </td>
                            <td>
                                <xsl:value-of select="hardware/memoria/text()" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul>
                                    <li>
                                        <xsl:value-of select=""/> 
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </xsl:template>
                </table>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
