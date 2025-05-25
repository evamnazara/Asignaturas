<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>
    
    <!--  plantilla 1: 
    Una que se aplique a la raíz del 
    documento que se encargue de crear los nuevos elementos raíz -->
        
    <xsl:template match="/Catálogo">
        <Equipamento>
            <Portátiles>
                <xsl:apply-templates select="Marca/Portatil"/>
            </Portátiles>
        </Equipamento>
    </xsl:template>

    <!-- plantilla 2:otra que se aplique a los elementos Portátil
    y los transforme en los nuevos elementos y atributos. -->
    <xsl:template match="Portatil">
        <Portatil>
            <xsl:attribute name="marca">
                <xsl:value-of select="../@nome"/>
            </xsl:attribute>
            <Ref>
                <xsl:value-of select="@ref"/>
            </Ref>
            <Nome>
                <xsl:value-of select="Texto"/>
            </Nome>
        </Portatil>
    </xsl:template>
</xsl:stylesheet>
