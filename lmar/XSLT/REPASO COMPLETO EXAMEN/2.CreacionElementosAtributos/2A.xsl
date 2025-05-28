<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>

    <xsl:template match="/">
        <xsl:element name="{cliente/@cod}" >
            <xsl:attribute name >
            <xsl:value-of  />
</xsl:attribute>
            
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
