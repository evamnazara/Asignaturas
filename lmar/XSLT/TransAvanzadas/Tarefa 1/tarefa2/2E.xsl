<?xml version="1.0"?>

<!--
Inclúa soamente as máquinas cuxo nome comeza por "PC".
Dentro da lista das máquinas, aparezan en primeiro lugar aquelas cuxo sistema operativo non sexa da familia "Windows".
As máquinas da familia "Windows" estean ordenadas pola capacidade total de almacenamento, en orde descendente.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>
    
    <!--Inclúa soamente as máquinas cuxo nome comeza por "PC". -->
    <xsl:template match="/OS">
        <xsl:sort > </xsl:sort>
    </xsl:template>
    <!--Dentro da lista das máquinas, aparezan en primeiro lugar aquelas cuxo sistema operativo non sexa da familia "Windows".. --> 
    <xsl:template match="/OS">
        <xsl:sort order="ascending"> </xsl:sort>
    </xsl:template>
    
    <!--As máquinas da familia "Windows" estean ordenadas pola capacidade total de almacenamento, en orde descendente. --> 
    <xsl:template match="/OS">
        <xsl:sort order="descending"> </xsl:sort>
    </xsl:template>

</xsl:stylesheet>
