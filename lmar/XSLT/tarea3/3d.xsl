<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>

    <!-- fuera del template
    -->
    <xsl:attribute-set name="atribMaquina">
        <xsl:attribute name="tipo">
            <xsl:value-of select="hardware/tipo" />
        </xsl:attribute>
 
        <xsl:attribute name="fabricante">
            <xsl:value-of select="hardware/fabricante" />
        </xsl:attribute>
        <!--
        <xsl:attribute name="procesador">
            <xsl:value-of select="concat(hardware/)" />
        </xsl:attribute> -->
        
    </xsl:attribute-set>
    
    <xsl:template match="/">    
        <xsl:element name="Máquina">
            <xsl:apply-templates select="/./máquina"/>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="máquina">
        <xsl:element name="máquina" use-attribute-sets="atribMaquina" />
    </xsl:template>
</xsl:stylesheet>
