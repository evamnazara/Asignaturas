<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/equipos">
    <html>
      <head>
        <title>Lista das maquinas</title>
      </head>
      <body>
        <h1>Maquinas</h1>
        <xsl:apply-templates select="máquina" mode="enlaces" />
        <xsl:apply-templates select="máquina" mode="descripcion"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="máquina" mode="enlaces">
        <p><a href="#PC017">PC017</a></p>
        <p><a href="#GALILEO">GALILEO</a></p>
  </xsl:template>
  
  <xsl:template match="máquina" mode="descripción">
        <xsl:variable name="pc017" select="máquina[@nome='PC017']"/>
        <h2 id="PC017">PC017</h2>
        <ul>
          <li><xsl:value-of select="$pc017/hardware/tipo"/></li>
          <li><xsl:value-of select="$pc017/hardware/fabricante"/></li>
          <li><xsl:value-of select="$pc017/hardware/procesador"/></li>
          <li>Memoria: <xsl:value-of select="$pc017/hardware/memoria"/> GB</li>
          <li>Disco: <xsl:value-of select="$pc017/hardware/disco/@capacidade"/>GB</li>
          <li>
            <xsl:text>gravadora de </xsl:text>
            <xsl:value-of select="$pc017/hardware/gravadora/@tipo"/>
          </li>
        </ul>

        <xsl:variable name="galileo" select="máquina[@nome='GALILEO']"/>
        <h2 id="GALILEO">GALILEO</h2>
        <ul>
            <xsl:apply-template select="hardware/*" ></xsl:apply-template>
        </ul>
  </xsl:template>

  <xsl:template match="memoria">
          <li>Memoria: <xsl:value-of select="text()"/> GB</li>
  </xsl:template>
  
  <xsl:template match="disco">
      <li>Disco: <xsl:value-of select="@capacidade"/> GB</li>
  </xsl:template>
  
  <xsl:template match="lectora/gravadora">
      <li> <xsl:value-of select="name()"/> </li>
  </xsl:template>
  
  <xsl:template match="*">
      <li> <xsl:value-of select="text()"/> </li>
  </xsl:template>
  
    
</xsl:stylesheet>
