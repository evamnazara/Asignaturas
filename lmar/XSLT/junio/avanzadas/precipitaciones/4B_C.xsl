<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>

    <xsl:variable name="numero" select="18" />
    <xsl:template match="/">
        <precipitaciones>
            <xsl:apply-templates select="precipitaciones/registro"/>
        </precipitaciones>
    </xsl:template>

    <xsl:template match="registro">
        <xsl:if test="(litros-m2 > $numero)" >
            <registro>
                <lugar>
                    <xsl:value-of select="lugar" />

                </lugar>
                <fecha>
                    <xsl:value-of select="fecha" />

                </fecha>
                <litros-m2>
                    <xsl:value-of select="litros-m2" />
                </litros-m2>
            </registro>
        </xsl:if>    
    </xsl:template>
</xsl:stylesheet>
