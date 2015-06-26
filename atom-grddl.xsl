<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:dcterms="http://purl.org/dc/terms/" 
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:grddl="http://www.w3.org/2003/g/data-view#" 
    xmlns:oreatom="http://www.openarchives.org/ore/atom/"
    version="2.0">


    <!-- atom-grddl.xsl  Version 1.0  Oct.  2008 -->
    <!-- Crosswalk from ORE Atom serialization to RDF -->
    <!-- Los Alamos National Laboratary  -->
    <!-- Research Library -->
    <!-- Digital Library Research and Prototyping Team -->
    <!-- Author: Lyudmila Balakireva -->
    <!-- Email: ludab@lanl.gov -->
    <!--
        Use and distribution of this code are permitted under the terms of the <a
        href="http://creativecommons.org/licenses/by-nc-sa/2.5/"
        >Attribution-Noncommercial-Share Alike Creative Commons License</a>.
        
    -->
    
    <xsl:output method="xml" indent="yes" />
    <!-- 
        scheme values in category treated as literal; 
    -->
    
    <ore:category>
        <ore:literal>http://www.openarchives.org/ore/atom/created</ore:literal>
        <ore:literal>http://www.openarchives.org/ore/atom/modified</ore:literal>
    </ore:category>
     
   
   
    
    <xsl:variable name="rem">http://www.openarchives.org/ore/terms/ResourceMap</xsl:variable>
    <xsl:variable name="desc">http://www.openarchives.org/ore/terms/describes</xsl:variable>
    
    <xsl:template match="atom:entry">
        <rdf:RDF>
            <!--  Information about   Resource Map  -->
            <rdf:Description>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="atom:link[@rel='self']/@href"/>
                </xsl:attribute>
                 <rdf:type>
                     <xsl:attribute name="rdf:resource"><xsl:value-of select="$rem"/></xsl:attribute>
                 </rdf:type> 
                <dcterms:isVersionOf>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="atom:id" />
                    </xsl:attribute>
                </dcterms:isVersionOf>
                <ore:describes>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="atom:link[@rel=$desc]/@href"/>
                    </xsl:attribute>
                </ore:describes>
                <xsl:if test="atom:updated">  
                    <dcterms:modified>
                        <xsl:value-of select="atom:updated"/>
                    </dcterms:modified>
                </xsl:if>
                <xsl:if test="atom:published">  
                    <dcterms:created>
                        <xsl:value-of select="atom:published"/>
                    </dcterms:created>
                </xsl:if> 
                
                <xsl:if test="atom:rights" >
                  <dc:rights>
                      <xsl:value-of select="atom:rights"/>
                  </dc:rights>
                </xsl:if>    
                
                <xsl:if test="atom:link[@rel='license']">
                    <dcterms:rights>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="atom:link[@rel='license']/@href" />
                    </xsl:attribute>
                    </dcterms:rights>
                </xsl:if>    
                <xsl:for-each select="atom:source/atom:author">
                    <xsl:call-template name="person"/>
                </xsl:for-each> 
                
            </rdf:Description>
         
            <!--  Atom entry ID -->
            <rdf:Description>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="atom:id"/>
                </xsl:attribute>
               
                <rdf:type  rdf:resource="http://bblfish.net/work/atom-owl/2006-06-06/#Entry"/>
                <xsl:if test="atom:source/atom:id">
                    <dcterms:isPartOf>
                        <xsl:attribute name="rdf:resource">
                            <xsl:value-of select="atom:source/atom:id" />
                        </xsl:attribute>
                     </dcterms:isPartOf>    
                </xsl:if>
            </rdf:Description> 
            
            <!-- Information about the Aggregation -->
        
            <rdf:Description>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="atom:link[@rel=$desc]/@href"/>
                </xsl:attribute>
              
              <ore:isDescribedBy>
                  <xsl:attribute name="rdf:resource">
                      <xsl:value-of select="atom:link[@rel='self']/@href"/>
                  </xsl:attribute>
              </ore:isDescribedBy>
                
                <xsl:for-each select="atom:category">
                                               
                        <xsl:variable name="name" >   
                           <xsl:call-template name="substring-after-last">
                        	<xsl:with-param name="input" select="@scheme"/>
                        		<xsl:with-param name="substr" select="'/'"/>
                           </xsl:call-template>
                        </xsl:variable >
                       <xsl:variable name="ns" >   
                        <xsl:call-template name="substring-before-last">
                            <xsl:with-param name="input" select="@scheme"/>
                            <xsl:with-param name="substr" select="'/'"/>
                        </xsl:call-template>
                       </xsl:variable >
                      <!--                    
                        <xsl:if test="(@scheme=document('')//ore:category/ore:literal)">
                            <xsl:element name="{$name}" namespace="{concat($ns,'/')}"   >
                            <xsl:value-of select="@term"/>
                            </xsl:element>
                       </xsl:if>
                    -->
                     <xsl:if test="(@scheme=document('')//ore:category/ore:literal)">
                         <xsl:element name="{$name}" namespace="http://purl.org/dc/terms/"   >
                            <xsl:value-of select="@term"/>
                        </xsl:element>
                     </xsl:if>
                    
                    <xsl:if test="not(document('')//ore:category/ore:literal=@scheme)">
                    
                        <xsl:choose>
                            
                            <xsl:when test ="contains(@term,':')">
                             <rdf:type>
                               <xsl:attribute name="rdf:resource">
                               <xsl:value-of select="@term" />
                               </xsl:attribute>  
                            </rdf:type>
                            </xsl:when>
                            
                           <xsl:otherwise>
                            <rdf:type>
                                <xsl:value-of select="@term" />
                            </rdf:type>
                           </xsl:otherwise>
                            
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
                
                <xsl:if test="atom:title" >
                    <dc:title>
                        <xsl:value-of select="atom:title"/>
                    </dc:title>
                </xsl:if>
                
                <xsl:for-each select="atom:author">
                    <xsl:call-template name="person"/>
                </xsl:for-each>
               
                <xsl:apply-templates select='atom:link' />
                
                <xsl:if test="atom:summary">
                <dcterms:abstract>  
                        <xsl:apply-templates select="atom:summary" mode="object"/>
                </dcterms:abstract>   
                </xsl:if>
                
                <xsl:for-each select="atom:contributor">
                    <xsl:call-template name="contributor"/>
                </xsl:for-each>
                
            </rdf:Description> 
            
            <xsl:apply-templates select='atom:category' mode="expansion"/>
            <xsl:apply-templates select='atom:link' mode="link_expansion"/>
            <xsl:apply-templates select='oreatom:triples/child::*' />
            <xsl:apply-templates select='atom:source' />
            <xsl:apply-templates select='atom:source/atom:category' mode="expansion"/>
        </rdf:RDF>    
    </xsl:template> 
    
                         
    <xsl:template match="oreatom:triples/child::*|@*|text()">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    
    <xsl:template match="*[not(*)]" mode="object">
        <xsl:copy-of select="@xml:lang"/>
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="*[*]" mode="object">
        <xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
        <xsl:copy-of select="@xml:lang"/>
        <xsl:copy-of select="node()"/>
    </xsl:template>
    
    <xsl:template match ="atom:source" >
        
        <xsl:if test="atom:id">    
        <rdf:Description>
          <xsl:attribute name="rdf:about">
           <xsl:value-of select="atom:id"/>
          </xsl:attribute>
         <rdf:type>
             <xsl:attribute name="rdf:resource">
                <xsl:value-of select="concat('http://bblfish.net/work/atom-owl/2006-06-06/#','Feed')" />
             </xsl:attribute> 
         </rdf:type> 
            <xsl:if test="atom:link/@rel='self'">
                <rdfs:seeAlso>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="atom:link[@rel='self']/@href" />
                    </xsl:attribute> 
                </rdfs:seeAlso>
            </xsl:if>
            <xsl:if test="atom:updated">  
                <dcterms:modified>
                    <xsl:value-of select="atom:updated"/>
                </dcterms:modified>
            </xsl:if>
            <xsl:if test="atom:title" >
                <dc:title>
                    <xsl:value-of select="atom:title"/>
                </dc:title>
            </xsl:if>
            
            <xsl:for-each select="atom:contributor">
                <xsl:call-template name="contributor"/>
            </xsl:for-each>
            
            <xsl:if test="atom:rights" >
                <dc:rights>
                    <xsl:value-of select="atom:rights"/>
                </dc:rights>
            </xsl:if>  
            
            <xsl:for-each select="atom:category">
                
                <xsl:variable name="name" >   
                    <xsl:call-template name="substring-after-last">
                        <xsl:with-param name="input" select="@scheme"/>
                        <xsl:with-param name="substr" select="'/'"/>
                    </xsl:call-template>
                </xsl:variable >
                <xsl:variable name="ns" >   
                    <xsl:call-template name="substring-before-last">
                        <xsl:with-param name="input" select="@scheme"/>
                        <xsl:with-param name="substr" select="'/'"/>
                    </xsl:call-template>
                </xsl:variable >
                
                <xsl:if test="(@scheme=document('')//ore:category/ore:literal)">
                    <xsl:element name="{$name}" namespace="{concat($ns,'/')}"   >
                        <xsl:value-of select="@term"/>
                    </xsl:element>
                </xsl:if>
                
                
                <xsl:if test="not(document('')//ore:category/ore:literal=@scheme)">
                    
                    <xsl:choose>
                        
                        <xsl:when test ="contains(@term,':')">
                            <rdf:type>
                                <xsl:attribute name="rdf:resource">
                                    <xsl:value-of select="@term" />
                                </xsl:attribute>  
                            </rdf:type>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <rdf:type>
                                <xsl:value-of select="@term" />
                            </rdf:type>
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                </xsl:if>
            </xsl:for-each>
            
        </rdf:Description>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="atom:link">
        
        <xsl:if test="contains(@rel,'/') and contains(@rel,':') and  @rel!=$desc" >
        <xsl:variable name="name" >   
            <xsl:call-template name="substring-after-last">
                <xsl:with-param name="input" select="@rel"/>
                <xsl:with-param name="substr" select="'/'"/>
            </xsl:call-template>
        </xsl:variable >
        
        <xsl:variable name="ns" >   
            <xsl:call-template name="substring-before-last">
                <xsl:with-param name="input" select="@rel"/>
                <xsl:with-param name="substr" select="'/'"/>
            </xsl:call-template>
        </xsl:variable >  
        
            <xsl:element name="{$name}" namespace="{concat($ns,'/')}"  >
                <xsl:attribute name="rdf:resource"> <xsl:value-of select="@href"/></xsl:attribute>
            </xsl:element>
            
        </xsl:if>
        
        
          <xsl:if test="@rel='alternate'">
              <rdfs:seeAlso><xsl:attribute name="rdf:resource"><xsl:value-of select="@href"/></xsl:attribute></rdfs:seeAlso>
          </xsl:if>
        
          <xsl:if test="@rel='related'">
              <rdfs:seeAlso><xsl:attribute name="rdf:resource"><xsl:value-of select="@href"/></xsl:attribute></rdfs:seeAlso>
          </xsl:if>
        
        
    </xsl:template>
    
    
    <xsl:template  match="atom:link" mode="link_expansion">
        <xsl:if test="(contains(@rel,'/') and contains(@rel,':')) or @rel='self' or @rel='license'" >
        <xsl:if test="(@type) or (@title) or (@hreflang) or (@length)" >
            <rdf:Description>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="@href"/>
                </xsl:attribute>
                <xsl:if test="@type" >
                    <dc:format>
                        <xsl:value-of select="@type"/>
                    </dc:format>
                </xsl:if> 
                <xsl:if test="@hreflang" >
                    <dc:language > 
                        <xsl:value-of select="@hreflang"/>
                    </dc:language>
                </xsl:if>
                <xsl:if test="@title" >
                    <dc:title> 
                        <xsl:value-of select="@title"/>
                    </dc:title>
                </xsl:if>    
                <xsl:if test="@length" >
                    <dcterms:extent> 
                        <xsl:value-of select="@length"/>
                    </dcterms:extent>
                </xsl:if>    
            </rdf:Description>
        </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="atom:category" mode="expansion">
        <xsl:if test="not(document('')//ore:category/ore:literal=@scheme)">
        <rdf:Description>
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="@term"/>
            </xsl:attribute>
            <rdfs:isDefinedBy>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="@scheme"/>
                </xsl:attribute>
            </rdfs:isDefinedBy>
            <rdfs:label xml:lang="en-US"> 
                <xsl:value-of select="@label"/>
            </rdfs:label>
        </rdf:Description>
        </xsl:if>
    </xsl:template>
        
        
        <xsl:template name="person" >
            <dcterms:creator rdf:parseType="Resource">
            
            <xsl:if test="atom:uri">
                <foaf:page>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="atom:uri" />
                    </xsl:attribute>
                </foaf:page>
            </xsl:if>
            <xsl:if test="atom:name">
                <foaf:name>
                    <xsl:value-of select="atom:name"/>
                </foaf:name>
            </xsl:if>
            
            <xsl:if test="atom:email">
                <foaf:mbox rdf:resource="mailto:{atom:email}"/>
            </xsl:if>
            
        </dcterms:creator>
        </xsl:template>
        
    <xsl:template name="contributor" >
        <dcterms:contributor rdf:parseType="Resource">
            
            <xsl:if test="atom:uri">
                <foaf:page>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="atom:uri" />
                    </xsl:attribute>
                </foaf:page>
            </xsl:if>
            <xsl:if test="atom:name">
                <foaf:name>
                    <xsl:value-of select="atom:name"/>
                </foaf:name>
            </xsl:if>
            
            <xsl:if test="atom:email">
                <foaf:mbox rdf:resource="mailto:{atom:email}"/>
            </xsl:if>
            
        </dcterms:contributor>
    </xsl:template>
   
    
    <xsl:template name="substring-before-last"> 
          <xsl:param name="input"/>
          <xsl:param name="substr"/>
          
          <xsl:if test="$substr and contains($input, $substr)">
                <xsl:variable name="temp" select="substring-after($input, $substr)" />
                <xsl:value-of select="substring-before($input, $substr)" />
                <xsl:if test="contains($temp, $substr)">
                     <xsl:value-of select="$substr" />
                     <xsl:call-template name="substring-before-last">
                           <xsl:with-param name="input" select="$temp" />
                            <xsl:with-param name="substr" select="$substr" />
                          </xsl:call-template>
                   </xsl:if>
             </xsl:if>
        
        </xsl:template>
    
    
    <xsl:template name="substring-after-last">
          <xsl:param name="input"/>
          <xsl:param name="substr"/>
          
         <xsl:variable name="temp" select="substring-after($input,$substr)"/>
          
          <xsl:choose>
              	<xsl:when test="$substr and contains($temp,$substr)">
                  		<xsl:call-template name="substring-after-last">
                      			<xsl:with-param name="input" select="$temp"/>
                      			<xsl:with-param name="substr" select="$substr"/>
                      		</xsl:call-template>
                 	</xsl:when>
             	<xsl:otherwise>
                  		<xsl:value-of select="$temp"/>
                  	</xsl:otherwise>
             </xsl:choose>
        </xsl:template> 
    
    
</xsl:stylesheet>