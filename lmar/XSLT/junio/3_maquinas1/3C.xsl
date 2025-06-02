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
                <a href="#{config/IP}"> <!-- llaveS? --> 
                    <xsl:value-of select="@nome" /> 
                </a>
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
            <td>
                <ul>
                    <xsl:apply-templates select="hardware/disco" />
                </ul>
            </td>
        </tr>
    </xsl:template>
    
  
    <xsl:template match="disco" >
        <li> 
            <xsl:value-of select="@capacidade"/>
            <xsl:text> GB </xsl:text>
            <xsl:value-of select="@tecnoloxía" />
        </li>
        
    </xsl:template> -->
</xsl:stylesheet>
