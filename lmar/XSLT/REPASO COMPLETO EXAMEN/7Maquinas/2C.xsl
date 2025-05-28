<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    
    <xsl:template match="/">
        <xsl:variable name="cabecera">
            <tr>
                <th>Maquina</th>
                <th>Tipo</th>
                <th>OS</th>
                <th>Capacidade</th>
            </tr>
        </xsl:variable>
        <html>
            <head>
                <title>Taboa das maquinas</title>
            </head>
            <body>
                <h1>Taboa das maquinas</h1>
                <table border="1">
                    <xsl:copy-of select="$cabecera" />
                    <!-- menos las q no sean impresores -->
                    <!-- -->
                    <xsl:apply-templates select="equipos/máquina[config/OS and not(starts-with(hardware/tipo,'Impresora'))]">
                        <!-- ordenar x capacidad -->
                        <xsl:sort select="sum(hardware/disco/@capacidade)" data-type="number" order="descending" />
  
                    </xsl:apply-templates>
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="máquina">
        <!--fondo amarelo aquelas máquinas de tip2o "PC Sobremesa" ou "Semitorre" -->
        
        <tr> <!-- si se van a poner atributos tienen q ir dentro xd-->
            <xsl:if test="contains(config/OS,'Windows')" >
                <xsl:attribute name="style">background-color:yellow </xsl:attribute>
            </xsl:if>
            
            <td>
                <xsl:value-of select="@nome"/> 
            </td>
            <td>
                <xsl:value-of select="hardware/tipo" />
            </td>
            <td>
                <xsl:value-of select="config/OS" />
            </td>
            <td>
                <xsl:variable name="capacidade" select="sum(hardware/disco/@capacidade)" />
                <xsl:attribute name="style"> color: 
                    <xsl:choose>
                        <xsl:when test="$capacidade &lt; 500">#FFA500</xsl:when>
                        <xsl:when test="$capacidade &lt; 1000">#FF4500</xsl:when>
                        <xsl:otherwise>#FF0000</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="sum(hardware/disco/@capacidade)" />GB
            </td>
            
        </tr>
        
    </xsl:template>

</xsl:stylesheet>
