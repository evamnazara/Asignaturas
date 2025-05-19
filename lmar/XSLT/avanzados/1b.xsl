<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Lista das Máquinas</title>
            </head>
            <body>
                <h1>Máquinas</h1> 
                <a href="{@nome}"> PC017 </a>
                <a href="{@nome}"> GALILEO </a>
                
                <h2><xsl:value-of select="{máquina/@nome}"/></h2>
                    
                <h2><xsl:value-of select="{máquina/@nome}"/></h2>
            </body>
            
        </html>
    </xsl:template>

</xsl:stylesheet>
