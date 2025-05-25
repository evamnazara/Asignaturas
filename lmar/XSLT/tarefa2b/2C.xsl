<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
   
    <xsl:template match="/">
    
        <xsl:variable name="title">Táboa máquinas</xsl:variable>
    
        <html>
            <head>
                <title>
                    <xsl:value-of select="$title"/>
                </title>
            </head>
            <body>
                <h1>
                    <xsl:value-of select="$title"/>
                </h1>
             
                <table border="1">
                    <tr>
                        <th>Máquina</th>
                        <th>Tipo</th>
                        <th>OS</th>
                        <th>Capacidade HD</th>
                    </tr>
                    <xsl:for-each select="equipos/máquina">
                    
                        <xsl:variable name="hdGB" select="sum(hardware/disco/@capacidade)"/>
                    
                        <xsl:sort select="sum(hardware/disco/@capacidade)" data-type="number" order="descending"/>
                    
                        <xsl:if test="not(starts-with(hardware/tipo,'Impresora'))">
                            <xsl:if test="config[OS]">
                                <tr>
                                    <xsl:if test="contains(config/OS,'Windows')">
                                        <xsl:attribute name="bgcolor">yellow</xsl:attribute>
                                    </xsl:if>
                                
                                    <td>
                                        <xsl:value-of select="@nome"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="hardware/tipo"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="config/OS"/>
                                    </td>
                                    <td>
                                        <xsl:attribute name="style">
                                            <xsl:choose>
                                                <xsl:when test="$hdGB &lt; 500">color: #FFA500</xsl:when>
                                                <xsl:when test="$hdGB &lt; 1000">color: #FF4500</xsl:when>
                                                <xsl:otherwise>color: #FF0000</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:value-of select="$hdGB"/> GB
                                    </td>
                                </tr>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                 
                </table>
             
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
