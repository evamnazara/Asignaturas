<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>taboa de maquinas</title>
            </head>
            <body>
                <h1>
                    Taboa de maquinas
                </h1>
                
                <table border="1">
                    <tr>
                        <th> Maquinas </th>
                        <th> Tipo </th>
                        <th> OS</th>
                        <th> Capacidade GB</th>
                    </tr>
               
                    <xsl:apply-templates select="equipos/máquina">
                        <!-- ordenados polo seu tipo, e dentro dos elementos 
                        dun mesmo tipo polo seu nome. -->
                        <xsl:sort select="tipo" order="descending"/>
                        <xsl:sort select="@nome" order="descending"/>
                    </xsl:apply-templates>
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="máquina">
        <xsl:if test="not(starts-with(hardware/tipo,'Impresora'))" >
            <tr>
                <!-- se anida el segundo if 
                <xsl:attribute name="style">bgcolor:yellow</xsl:attribute>-->
                <xsl:if 
                    test="hardware/tipo = 'PC Sobremesa' or hardware/tipo = 'Semitorre'" >
                    <xsl:attribute name="style">background-color:yellow; </xsl:attribute>
                </xsl:if>  
                    
                <td>
                    <xsl:value-of select="@nome" />
                </td>
                <td>
                    <xsl:value-of select="hardware/tipo" />
                </td>
                <td>
                    <xsl:value-of select="config/OS" />
                </td>
                <td>
                    <xsl:value-of select="hardware/disco/@capacidade"/>
                </td>
            </tr>
        </xsl:if>
        
    </xsl:template>

</xsl:stylesheet>
