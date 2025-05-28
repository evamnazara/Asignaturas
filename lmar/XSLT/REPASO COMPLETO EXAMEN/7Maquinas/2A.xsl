<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Taboa das maquinas</title>
            </head>
            <body>
                <h1>Taboa das maquinas</h1>
                <table border="1">
                    <tr>
                        <th>Maquina</th>
                        <th>Tipo</th>
                        <th>OS</th>
                        <th>Capacidade</th>

                    </tr>
                    <!-- menos las q no sean impresores -->
                    <!-- -->
                    <xsl:apply-templates select="equipos/máquina[not(starts-with(hardware/tipo,'Impresora'))]">
                        <xsl:sort select="hardware/tipo" />
                        <xsl:sort select="@nome" />
                    </xsl:apply-templates>
                   
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="máquina">
        <!--fondo amarelo aquelas máquinas de tip2o "PC Sobremesa" ou "Semitorre" -->
        
        <tr> <!-- si se van a poner atributos tienen q ir dentro xd-->
            <xsl:if test="hardware/tipo='PC Sobremesa' or hardware/tipo='Semitorre'" >
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
                <xsl:value-of select="sum(hardware/disco/@capacidade)" />GB
            </td>
            
        </tr>
        
    </xsl:template>

</xsl:stylesheet>
