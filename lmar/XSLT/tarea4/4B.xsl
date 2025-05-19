<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/horario">
        <html>
            <head>
                <title>Asignaturas por día</title>
            </head>
            <body>
                <h1>Asignaturas por día</h1>
                <xsl:apply-templates select="dia"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="dia">
        <h3>Día <xsl:value-of select="@num"/></h3>
        <ul>
            <xsl:apply-templates select="materia"/>
        </ul>
    </xsl:template>

    <xsl:template match="materia">
        <li>
            <xsl:choose>
                <xsl:when test="@nome">
                    <xsl:value-of select="@nome"/>
                </xsl:when>
            </xsl:choose>
        </li>
    </xsl:template>
</xsl:stylesheet>
