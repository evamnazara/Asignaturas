<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>
    
    <!-- empezar desde el principio -->
    <xsl:template match="/" >
        <!--NO element-->
        <almacenamento>
            <discos>
                <xsl:attribute name="num">
                    <xsl:value-of select="count(equipos/máquina/hardware/disco)" /> 
                </xsl:attribute>
                
                <xsl:apply-templates 
                    select="equipos/máquina/hardware/disco" mode="discos" />
            </discos>
            
            <memorias>
                <xsl:attribute name="num">
                    <xsl:value-of select="count(equipos/máquina/hardware/memoria)" />
                </xsl:attribute>
                <xsl:apply-templates 
                    select="equipos/máquina/hardware/memoria" mode="memorias" /> 
            </memorias>
        </almacenamento>
    </xsl:template>
    
    <xsl:template match="disco" mode="discos" >
        <disco>
            <xsl:attribute name="tecnoloxía">
                <xsl:value-of select="@tecnoloxía" />
            </xsl:attribute>
            <xsl:attribute name="capacidade">
                <xsl:value-of select="@capacidade" />
            </xsl:attribute>
        </disco>
    </xsl:template>
        
    <xsl:template match="memoria" mode="memorias">
        <memoria>
            <xsl:attribute name="tecnoloxía">
                <xsl:value-of select="@tecnoloxía" />
            </xsl:attribute>
            <xsl:value-of select="." />
        </memoria>
    </xsl:template>
    <!-- 
    <xsl:template 
        match="disco" mode="discos">
        
        <xsl:element name="disco">
            <disco>
                <xsl:attribute name="tecnoloxía">
                    <xsl:value-of select="@tecnoloxía"/>
                </xsl:attribute>
                <xsl:attribute name="capacidade">
                    <xsl:value-of select="@capacidade"/>
                </xsl:attribute>
            </disco>
        </xsl:element>
    </xsl:template>
    -->
   
    

</xsl:stylesheet>


<!--
<?xml version="1.0" encoding="UTF-8"?>
<almacenamento>
  <discos num="4">
    <disco tecnoloxía="SATA" capacidade="2000"/>
    <disco tecnoloxía="SCSI" capacidade="200"/>
    <disco tecnoloxía="SCSI" capacidade="200"/>
    <disco tecnoloxía="SCSI" capacidade="200"/>
  </discos>
  <memorias num="2">
    <memoria tecnoloxía="DDR3">8</memoria>
    <memoria tecnoloxía="DDR2">2</memoria>
  </memorias>
</almacenamento>

-->