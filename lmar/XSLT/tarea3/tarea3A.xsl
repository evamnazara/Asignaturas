<?xml version="1.0"?>

<!--
    Document   : tarea3A.xsl
    Created on : 13 de mayo de 2025, 8:54
    Author     : eoternaza
    Description:
        Purpose of transformation follows.
-->
<!--
<xsl:attribute-set name="atr_discos">
    <xsl:attribute name="tecnoloxía">
        <xsl:value-of select="/disco/@tecnoloxía" />
    </xsl:attribute>
    <xsl:attribute name="capacidade"> 
        <xsl:value-of select="/disco/@capacidade" />
    </xsl:attribute>
</xsl:attribute-set>
--> 
<!-- <xsl:element name="disco" use-attribute-sets="atr_discos"/> -->

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
        <xsl:attribute name="máquina"> 
            <xsl:value-of select="../../@nome" /> <!-- se parte desde disco-->
        </xsl:attribute>
    </xsl:template>
    
</xsl:stylesheet>
