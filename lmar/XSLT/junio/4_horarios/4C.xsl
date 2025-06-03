<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>

    <xsl:template match="/">
        <xsl:element name="materias"> 
            <materias>
                <dia>
                    <materia>
                        <xsl:apply-templates select="dia" />
                    </materia>
                </dia>
            </materias>
        </xsl:element>
    </xsl:template>

    <xsl:template match="dia">
        <xsl:element name="dia">
      
            <xsl:attribute name="num" />
            <xsl:value-of select=""
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
