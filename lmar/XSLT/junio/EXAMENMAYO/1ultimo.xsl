<?xml version="1.0"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Alojamientos</title>
            </head>
            <body>
                <h1>
                    <xsl:attribute name="style">
                        color:red;
                    </xsl:attribute>
                    Hoteles</h1>
                
                <xsl:apply-templates select="alojamientos/hoteles/hotel" mode="lista">
                    <xsl:sort select="@estrellas" order="descending" />
                    <xsl:sort select="nombre" order="descending" />
                    <xsl:sort select="count(servicios)" order="descending" />

                </xsl:apply-templates>
                <hr/>
                
                <xsl:apply-templates select="alojamientos/hoteles/hotel" mode="detalle">
                    <xsl:sort select="@estrellas" order="descending" />
                    <xsl:sort select="nombre" order="descending" />
                    <xsl:sort select="count(servicios)" order="descending" />
                </xsl:apply-templates> 
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="hotel" mode="lista">
        <a>
            <xsl:attribute name="href">#<xsl:value-of select="@id" />
            </xsl:attribute>
            <xsl:value-of select="nombre" />
            
            <xsl:if test="@estrellas">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="@estrellas" />
                <xsl:text> estrellas)</xsl:text>
            </xsl:if>
        </a>
        <br/>
    </xsl:template>
    
    
    <xsl:template match="hotel" mode="detalle">
        <h2>
            <xsl:attribute name="id">
                <xsl:value-of select="@id" />
            </xsl:attribute>
            
            
            <xsl:value-of select="nombre" />
        </h2>
        
        <xsl:value-of select="observaciones" />
        
        <ul>
            <xsl:if test="instalaciones/piscina">
                <li> Piscina: ( 
                    <xsl:value-of select="count(instalaciones/piscina)" />
                    )</li>
            </xsl:if>
            <xsl:if test="restaurantes/restaurante">
                <li> Restaurantes: ( 
                    <xsl:value-of select="count(restaurantes/restaurante)" />
                    )</li>
            </xsl:if>
            <xsl:if test="servicios">
                <li> Servicios: 
                    <ul>
                        <xsl:apply-templates select="servicios">
                            
                        </xsl:apply-templates>
                    </ul>
                </li>
            </xsl:if>
        </ul>
    </xsl:template> 
    
    <xsl:template match="servicios">
 
        <xsl:for-each select="*">
            <xsl:sort select="name()" order="ascending" />
                
            <li>
                <xsl:value-of select="name()"/>
            </li>
        </xsl:for-each>
        
    </xsl:template>
    

</xsl:stylesheet>
