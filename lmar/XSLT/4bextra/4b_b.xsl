<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>
    
    <xsl:param name="lugar" select="'Vigo'"/>

    <xsl:template match="/">
        <precipitaciones>
            <lugar>
                <xsl:value-of select="$lugar" />
            </lugar>
            <xsl:for-each select="precipitaciones/registro[lugar = $lugar]" >
                <registro>
                    <fecha>
                        <xsl:value-of select="fecha"/>
                    </fecha>
                    <litros-m2>
                        <xsl:value-of select="litros-m2"/>
                    </litros-m2>
                </registro>
            </xsl:for-each>

        </precipitaciones>
    </xsl:template>

</xsl:stylesheet>
