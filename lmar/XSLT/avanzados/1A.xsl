<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>

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
    <xsl:template match="/hardware"> 
        <almacenamiento>
            <disco tecnoloxía="{@tecnoloxía}" capacidade="{@capacidade}">
                <xsl:apply-templates select="disco"/>
            </disco>
        </almacenamiento>
    </xsl:template>

</xsl:stylesheet>
