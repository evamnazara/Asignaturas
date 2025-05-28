<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="text"/>

    <!-- Cando no documento orixe existe o produto co atributo "cod="LACT012"", o documento de saída deberá conter o texto "Atopado!!".
    -->
     <xsl:template match="/">
        <xsl:if test="//produto[@cod='LACT012']">
            Atopado!!
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
