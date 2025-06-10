<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>

    <xsl:template match="/">
        <vivero>
            <Árboles>
                <xsl:apply-templates select="vivero/seccion" />
            </Árboles>
        </vivero>
    </xsl:template>
    <xsl:template match="seccion">
        <xsl:if test="@nombre = 'arboles'">
            <árbol>
                <xsl:attribute name="num"> 
                    <xsl:value-of select="" /> 
                </xsl:attribute>
                <xsl:attribute name="familia"> 
                    <xsl:value-of select="" /> 
                </xsl:attribute>
                
                <xsl:attribute name="num" > 
                    <xsl:value-of select="" /> 
                </xsl:attribute>

                
            </árbol>
        </xsl:if>
        
    </xsl:template>

</xsl:stylesheet>
