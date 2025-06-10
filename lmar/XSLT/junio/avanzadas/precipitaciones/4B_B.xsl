<?xml version="1.0"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>

    <xsl:variable name="lugar" select="'Lugo'" />
    
    
    <xsl:template match="/">
            <precipitaciones>
                <lugar> 
                    <xsl:value-of select="$lugar" />
                </lugar>
                <xsl:apply-templates select="precipitaciones/registro[lugar = $lugar]" />
            </precipitaciones>
    </xsl:template>
    
    <xsl:template match="registro">
        <fecha>
            <xsl:value-of select="fecha"/>
        </fecha>
        <litros-m2>
            <xsl:value-of select="litros-m2" />
        </litros-m2>
    </xsl:template>

</xsl:stylesheet>
