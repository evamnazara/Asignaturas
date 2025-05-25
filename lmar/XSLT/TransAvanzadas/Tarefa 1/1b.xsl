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
        
        <p><a href="#PC017">PC017</a></p>
        <p><a href="#GALILEO">GALILEO</a></p>

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
          <li><xsl:value-of select="$galileo/hardware/tipo"/></li>
          <li><xsl:value-of select="$galileo/hardware/fabricante"/></li>
          <li><xsl:value-of select="$galileo/hardware/procesador"/></li>
          <li>Memoria: <xsl:value-of select="$galileo/hardware/memoria"/>GB</li>

          <xsl:copy-of select="$galileo/hardware/disco[position()=1]"/>
          <li>Disco: <xsl:value-of select="$galileo/hardware/disco[1]/@capacidade"/>GB</li>
          <li>Disco: <xsl:value-of select="$galileo/hardware/disco[2]/@capacidade"/>GB</li>
          <li>Disco: <xsl:value-of select="$galileo/hardware/disco[3]/@capacidade"/>GB</li>
          <li>
            <xsl:text>lectora de </xsl:text>
            <xsl:value-of select="$galileo/hardware/lectora/@tipo"/>
          </li>
        </ul>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
