<?xml version="1.0"?>

<!--
    Document   : 2A.xsl
    Created on : 5 de junio de 2025, 8:57
    Author     : eoternaza
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Lista das maquinas</title>
            </head>
            <body>
                <h1>Máquinas</h1>
                
                <xsl:apply-templates select="equipos/máquina" mode="enlaces" />
                <xsl:apply-templates select="equipos/máquina" mode="cuerpo" /> 
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="máquina" mode="enlaces">
        <p>
            <a href="#@nome"> 
                <xsl:value-of select="@nome" />
            </a>
        </p>
    </xsl:template>
    
    <xsl:template match="máquina" mode="cuerpo">
        <h2>
            <xsl:value-of select="@nome"/>
        </h2>
        <ul> 
            <!-- quieres coger todos los hijos, así que ruta/* -->
            <xsl:apply-templates select="hardware/*" mode="lista" />
        </ul>
    </xsl:template>
    
      <!-- y el li se crea de cada hijo  -->
    <xsl:template match="*" mode="lista">
        <li>
            <xsl:choose>
                <xsl:when test="name()='disco'">
                    <xsl:text> Disco: </xsl:text>
                    <xsl:value-of select="@capacidade" />
                </xsl:when>
                
                <xsl:when test="name()='memoria'">
                    <xsl:text> Memoria: </xsl:text>
                    <xsl:value-of select="." />
                    <xsl:text> GB. </xsl:text>
                </xsl:when>
                
                <xsl:when test="name() = 'lectora' or name() = 'gravadora'">
                        <xsl:value-of select="name()" />
                        de
                        <xsl:value-of select="@tipo" />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="." />
                </xsl:otherwise>
                
            </xsl:choose>
        </li>
            
    </xsl:template>
    

</xsl:stylesheet>
