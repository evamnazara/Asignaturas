<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/horario">
    <html>
      <head>
        <title>Horario de <xsl:value-of select="@ciclo"/></title>
      </head>
      <body>
        <h1>Horario <xsl:value-of select="@ciclo"/>, ano <xsl:value-of select="@ano"/></h1>
        <table border="1">
          <tr>
            <th></th>
            <th>Inicio</th>
            <th>Fin</th>
          </tr>
          <xsl:apply-templates select="horas/hora"/>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="hora">
    <tr>
      <td>
        <xsl:value-of select="concat(@id, ' Hora')"/>
      </td>
      <td>
        <xsl:value-of select="inicio"/>
      </td>
      <td>
        <xsl:value-of select="fin"/>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
