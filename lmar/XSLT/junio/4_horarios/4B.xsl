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
                <h1>Asignaturas por dia</h1>
                <ul>
                    
                    <xsl:apply-templates select="horario/dia" />
                </ul>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="dia">
        <li>
            <xsl:text>Dia </xsl:text>
            <xsl:value-of select="@num" />
        </li>
        <ul>
            <xsl:apply-templates select="materia" />
        </ul>
        
    </xsl:template>
    
    <xsl:template match="materia">
        <li>
            <xsl:value-of select="@nome" />
        </li>
    </xsl:template>

</xsl:stylesheet>
