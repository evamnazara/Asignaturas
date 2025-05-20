<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>

    <xsl:template match="/equipos">
        <almacenamento>
            <discos>
                <xsl:attribute name="num">
                    <xsl:value-of select="{count(//disco)}"/>
                </xsl:attribute>
                <xsl:copy-of select="//disco"/>
            </discos>

            <memorias>
                <xsl:attribute name="num">
                    <xsl:value-of select="{count(//memoria)}"/>
                </xsl:attribute>
                <xsl:copy-of select="equipos/máquina/hardware/memoria"/>
            </memorias>
        </almacenamento>
    </xsl:template>

</xsl:stylesheet>
