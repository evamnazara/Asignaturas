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
            <xsl:if  test="not(starts-with(hardware/tipo,'Impresora'))" >
            <tr>
   
                <td>
                    <xsl:value-of select="@nome" />
                </td>
                <td>
                    <xsl:value-of select="hardware/tipo" />
                </td>
            </tr>
        </xsl:if>
        
    </xsl:template>

</xsl:stylesheet>
