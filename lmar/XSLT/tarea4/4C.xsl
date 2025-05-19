<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/horario">
    <materias>
      <xsl:apply-templates select="dia"/>
    </materias>
  </xsl:template>

  <xsl:template match="dia">
    <dia num="{@num}">
      <xsl:apply-templates select="materia"/>
    </dia>
  </xsl:template>

  <xsl:template match="materia">
    <materia>
      <xsl:copy-of select="@*"/>
    </materia>
  </xsl:template>

  <xsl:template match="horas"/>

</xsl:stylesheet>
