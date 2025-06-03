<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
   
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:text> Horario  </xsl:text>
                    <xsl:value-of select="horario/@ciclo" />
                   
                </title>
            </head>
            <body>
                <h1> <xsl:text> Horario  </xsl:text>
                    <xsl:value-of select="horario/@ciclo" />
                    <xsl:text>, ano  </xsl:text>
                    <xsl:value-of select="horario/@ano" /></h1>
                <table border="1">
                    <tr>
                        <th></th>
                        <th>Inicio</th>
                        <th>Fin</th>
                    </tr>
                    <xsl:apply-templates select="horario/horas/hora" />
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="hora">
        <tr>
            <th>
                <xsl:value-of select="@id" />
                <xsl:text> Hora</xsl:text>
            </th>
            <td>
                <xsl:value-of select="inicio" />
            </td>
            <td>
                <xsl:value-of select="fin" />
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
