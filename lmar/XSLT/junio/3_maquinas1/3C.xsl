<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Taboa maquinas</title>
            </head>
            <body>
                <table border="1">
                    <tr>
                        <th>Maquinas</th>
                        <th>Procesador</th>
                        <th>Memoria</th>
                        <th>Disco(s)</th>
                    </tr>
                    <xsl:apply-templates select="equipos/máquina" />
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="máquina">
        <tr>
            <td>
                <a href="config/IP"> <xsl:value-of select="@nome" /> </a>
            </td>
            <td>
                <xsl:value-of select="hardware/procesador/@marca"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="hardware/procesador" />
            </td>
            <td>
                <xsl:value-of select="hardware/memoria"/>
                <xsl:text>GB </xsl:text>
                <xsl:value-of select="hardware/memoria/@tecnoloxía"/>
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template match="hardware/disco" >
            <td>
                <ul>
                    <li>
                        <xsl:value-of select="/@capacidade"/>
                    </li>
                </ul>
            </td>
    </xsl:template>
</xsl:stylesheet>
