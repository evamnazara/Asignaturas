<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>

    <xsl:template match="/">
        <xsl:element name="Catálogo">
            <Equipamento>
                <Portátiles>
                        <!-- NO HACE FALTA seguir la estructura literal de xml original  -->
                    <xsl:apply-templates select="Catálogo/Marca/Portatil" />
                </Portátiles>
                
            </Equipamento>
        </xsl:element>
    </xsl:template>

    <xsl:template match="Portatil" >
        <xsl:element name="Portatil">
            <xsl:attribute name="marca">
                <!-- HACIA ATRAS solo dos puntos !! -->
                <xsl:value-of select="../@nome" />
            </xsl:attribute>
            <Ref>
                <xsl:value-of select="@ref" />
            </Ref>
            <Nome>
                 <xsl:value-of select="Texto" />

            </Nome>
            
           <!-- <xsl:text>
                prueba
            </xsl:text>  -->
        </xsl:element>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>
