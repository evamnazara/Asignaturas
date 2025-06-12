<?xml version="1.0"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>

    <xsl:template match="/">
        <vivero>
            <Árboles>
                <xsl:apply-templates select="vivero/seccion[@nombre ='arboles']/Familia/arbol" mode="arboles" />
            </Árboles>
            
            <Plantas>
                <xsl:apply-templates select="vivero/seccion[@nombre ='plantas']/Familia" mode="plantas" />
            </Plantas>
        </vivero>
    </xsl:template>
    
    <xsl:template match="Familia" mode="arboles">
        <árbol>
                <xsl:attribute name="num"> 
                    <xsl:value-of select="position()" /> 
                </xsl:attribute>
                <xsl:attribute name="familia"> 
                    <xsl:value-of select="../@nombre" /> 
                </xsl:attribute>
                
                <xsl:attribute name="proveedor" > 
                    <xsl:value-of select="../@proveedor" /> 
                </xsl:attribute>
                
                <Ref>
                    <xsl:value-of select="@ref" />
                </Ref>
                <Descripcion>
                    <xsl:value-of select="Descripcion"/>
                </Descripcion>
                
                <Habitat>
                    <xsl:value-of select="Habitat"/>
                </Habitat>
                
                <Altura> 
                    <xsl:value-of select="Altura"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="Altura/@unidad"/>
                </Altura>
                <Copa> 
                    <xsl:value-of select="Copa"/>
                </Copa>
                <Hojas>
                    <xsl:value-of select="Hojas"/>
                </Hojas>
                <Flores>
                    <xsl:value-of select="Flores"/>
                </Flores>
                <Raices>
                    <xsl:value-of select="Raices"/>
                </Raices>
                <Frutos>
                    <xsl:value-of select="Frutos"/>
                </Frutos>
            </árbol>
    </xsl:template>
    
    <xsl:template match="Familia" mode="plantas">
            <Planta>
                <xsl:attribute name="num">
                    <xsl:value-of select="position()" />
                </xsl:attribute>
                <xsl:attribute name="Familia">
                    <xsl:value-of select="@nombre" />
                </xsl:attribute>
                
                <Ref>
                    <xsl:value-of select="planta/@ref" />
                </Ref>
                <Descripcion>
                     <xsl:value-of select="planta/Descripcion" />
                </Descripcion>
            </Planta>
    </xsl:template>

</xsl:stylesheet>
