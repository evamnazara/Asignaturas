<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>
    <xsl:template match="equipos"> <!-- se parte desde aqui -->
        <discos> 
            <xsl:apply-templates select ="máquina/hardware/disco" />
        </discos>
    </xsl:template>
    
    <xsl:template match="disco">
        <xsl:attribute name="tecnoloxía"> 
            <xsl:value-of select="@tecnoloxía" /> <!-- se parte desde disco-->
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="disco">
        <xsl:attribute name="capacidade"> 
            <xsl:value-of select="capacidade" /> <!-- se parte desde disco-->
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="disco">
        <li>
            <xsl:value-of select="@capacidade"/> GB (xsl: text( (<xsl:value-of select="@tecnoloxía"/>))
        </li>
    </xsl:template> 
    
</xsl:stylesheet>
