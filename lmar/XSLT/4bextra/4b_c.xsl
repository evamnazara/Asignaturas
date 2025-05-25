<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>

   
  <xsl:param name="maximo" select="3"/>

    <xsl:template match="/">
        <precipitaciones>
            <xsl:for-each select="precipitaciones/registro">
                <xsl:sort select="number(litros-m2)" data-type="number" order="descending"/>
                
                <xsl:if test="position() &lt;= $maximo">
                    <registro>
                        <lugar><xsl:value-of select="lugar"/></lugar>
                        <fecha><xsl:value-of select="fecha"/></fecha>
                        <litros-m2><xsl:value-of select="litros-m2"/></litros-m2>
                    </registro>
                </xsl:if>
            </xsl:for-each>
        </precipitaciones>
    </xsl:template>

</xsl:stylesheet>
