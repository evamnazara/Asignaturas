<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>

    <xsl:template match="/">
    <html>
      <body>
          <h1>HTML</h1>
        <div style="border: 1px solid black; 
                    padding: 5px; 
                    width: 400px;">
          <h2 style="text-align:center;">CLIENTES Y TIPOS DE POLIZAS</h2>

          <xsl:for-each select="polizas/poliza">
            <p>
              <xsl:value-of select="cliente"/>, Tipo de poliza: <xsl:value-of select="@tipo"/>
            </p>
          </xsl:for-each>

        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
