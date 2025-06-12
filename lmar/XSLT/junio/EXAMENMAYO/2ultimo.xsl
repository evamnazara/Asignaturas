<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>

    <xsl:template match="/">
        <vivero>
            <xsl:if test="vivero/seccion[@nombre= 'arboles']/Familia/arbol">
                <Árboles>
                    <xsl:apply-templates select="vivero/seccion/Familia" mode="arboles" />
                </Árboles>
            </xsl:if>
                
            
            
            <Planta>
                
            </Planta>
        </vivero>
    </xsl:template>

    <xsl:template match="arbol" mode="arboles">
        <arbol>
            
            <xsl:attribute name="num">
                <xsl:value-of select="position()" />
            </xsl:attribute>
            <xsl:attribute name="familia">
                <xsl:value-of select="@nombre" />
            </xsl:attribute>
            <xsl:attribute name="proveedor">
                <xsl:value-of select="../../proveedores/@nombre" />
            </xsl:attribute> 
        </arbol>
    </xsl:template>
</xsl:stylesheet>
