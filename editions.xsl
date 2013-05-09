<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet
  exclude-result-prefixes="xd exsl estr edate a fo local rng tei teix"
  extension-element-prefixes="exsl estr edate" version="1.0"
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:edate="http://exslt.org/dates-and-times"
  xmlns:estr="http://exslt.org/strings" xmlns:exsl="http://exslt.org/common"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:local="http://www.pantor.com/ns/local"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:xd="http://www.pnp-software.com/XSLTdoc"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xd:doc type="stylesheet">
    <xd:short> TEI stylesheet dealing with elements from the drama module,
      making HTML output. </xd:short>
    <xd:detail> This library is free software; you can redistribute it and/or
      modify it under the terms of the GNU Lesser General Public License as
      published by the Free Software Foundation; either version 2.1 of the
      License, or (at your option) any later version. This library is
      distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
      without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
      PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
      details. You should have received a copy of the GNU Lesser General Public
      License along with this library; if not, write to the Free Software
      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA </xd:detail>
    <xd:author>See AUTHORS</xd:author>
    <xd:cvsId>$Id: drama.xsl 4801 2008-09-13 10:05:32Z rahtz $</xd:cvsId>
    <xd:copyright>2008, TEI Consortium</xd:copyright>
  </xd:doc>
  <xd:doc>
    <xd:short>Process elements tei:actor</xd:short>
    <xd:detail> </xd:detail>
  </xd:doc>
  <xsl:output method="html" encoding="UTF-8"/>
<xsl:strip-space elements="*"/>
<xsl:preserve-space elements="tei:c"/>
  <xsl:template match="/">
	<html>
	<head>
	  <title><xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></title>
	<style type="text/css" media="screen,print">@import "editions.css";</style>
	<!--jQuery Stuff--> 
	<script type="text/javascript" src="jquery-1.9.1.min.js" />
	<script type="text/javascript"> 
	 $(document).ready(function() {
	 //alert('working!'); 
	 	//set them all to unchecked by default
		$("input.charCheckbox").each(function(){ this.checked = false }); 

	 	//set options boxes to unchecked by default
		$("[type='checkbox'].optionsCheckbox").each(function(){ this.checked = true }); 

		$('#selectAll').change(function() {
		    var checkboxes = $('.charCheckbox');
		    if($(this).is(':checked')) {
			checkboxes.prop('checked', 'true');
		    } else {
			checkboxes.removeAttr('checked');
		    }
		});

		$('input.charCheckbox').click(function(){
		    var myID='.dialog#'+$(this).attr('id'); 
		    var everythingElse='.dialog:not('+myID+')'
		      if ($(this).is(':checked')){
			   $(myID).addClass("red");
			   $(myID).clone().appendTo("div#dialogOnly"); 
			   //$(everythingElse).addClass("blue"); 
		      } else { 
			   $(myID).removeClass("red");
			   $("div#dialogOnly "+myID).remove();
			   //$(everythingElse).removeClass("blue"); 
		      }
		      return true;
		   }); 
		 

	 }); 
	</script> 
	<!-- End jQuery Stuff --> 
  <script type="text/javascript">
    function showHideLineNbrs() {
      var obj = document.getElementById('LineNbrBtn');
      if (obj.innerHTML == "Hide Line Nbrs") {
        hideLineNbrs();
        obj.innerHTML = "Show Line Nbrs";
        obj.title = "Show FTLN and Line Numbers";
      } else {
        obj.innerHTML = "Hide Line Nbrs";
        obj.title = "Hide Line Numbers (e.g., for cut and paste)";
        showLineNbrs();
      }
    }
    function hideLineNbrs() {
      var objs = document.getElementById('pageBlock').getElementsByTagName('a');
      for (var i = objs.length-1; i >= 0; i--) {
        objs[i].innerHTML = "";
      }
    }
    function showLineNbrs() {
      var objs = document.getElementById('pageBlock').getElementsByTagName('a');
      for (var i = objs.length-1; i >= 0; i--) {
        if (objs[i].className == 'ftln') {
          var str = objs[i].name.toUpperCase();
          objs[i].innerHTML += str.replace('-',' ');
        }
        if (objs[i].className == 'lineNbr') {
          var str = objs[i].name;
          var lineNbr= str.substr(str.lastIndexOf('.')+1);
          if (lineNbr>0) {
          if (lineNbr%5==0) {
            objs[i].innerHTML += str.substr(str.lastIndexOf('.')+1);
          }
          }
        }
      }
    }
    
    alignSplitLinesCmd = "";
    function alignSplitLines(line,prevLine,startOrEnd) {
        var targets = prevLine.split(' ');
        if (targets.length > 1) {
          var lastTarget = targets[targets.length-1];
        } else {
          var lastTarget = String(targets);
        }       
        lastTarget = lastTarget.replace('#','');
        if (lastTarget) {
          obj = document.getElementById(line);
          pObj = document.getElementById(lastTarget);
          var padding = (pObj.offsetLeft + pObj.offsetWidth) - obj.offsetLeft + obj.offsetWidth + "px";
          if (startOrEnd == 'E') {
            var padding = (pObj.offsetLeft + pObj.offsetWidth) - obj.offsetLeft + obj.offsetWidth + "px";
            } else {
            var padding = (pObj.offsetLeft) - obj.offsetLeft + obj.offsetWidth + "px";
          }
          if (parseInt(padding) &lt; 0) { padding = "0px"; }
          obj.style.paddingLeft = padding;
        }
    }

    alignSegsCmd = "";
    function alignSegs(id,id1,seg) {
      var pad0 = 15;
      var obj = document.getElementById(id);
      var obj1 = document.getElementById(id1);
      if (obj !== obj1) {
        var padding = (obj1.offsetLeft - obj.offsetLeft) + (obj1.offsetWidth - obj.offsetWidth) + parseInt(obj.style.paddingLeft);
        obj.style.paddingLeft = padding + 'px';
      } else {
        if (seg) {
          var objx = document.getElementById(seg);
          newpadding = (430-objx.offsetWidth)/2;
          padding = newpadding + pad0 - (obj.offsetLeft+obj.offsetWidth);
          if (padding &lt; 10) { padding = 10; }
          obj.style.paddingLeft = padding + 'px';
        }
      }
    }
    //window.onload=function() { eval(alignSplitLinesCmd);};
    //window.onload=function() { eval(alignSegsCmd);};
    window.onload=function() { eval(alignSplitLinesCmd); eval(alignSegsCmd);};
  </script>
	</head>
        <body>
          <div id="pageBlock" class="pageBlock">
            <div class="textBlock">
	            <xsl:apply-templates/>
            </div>
          </div>
        </body>
        </html>
  </xsl:template>

  <xsl:template match="tei:del">
  </xsl:template>
  <xsl:template match="tei:app">
  </xsl:template>

  <xsl:variable name="rdg" select="'lemma'" />
  <xsl:variable name="texta" select="//tei:interp[@xml:id='texta']" />
  <xsl:variable name="textb" select="//tei:interp[@xml:id='textb']" />

  <xsl:template match="tei:teiHeader">
    <xsl:apply-templates select="//tei:titleStmt"/>
    <xsl:apply-templates select="//tei:particDesc"/>
  </xsl:template>
  <xsl:template match="tei:back">
  </xsl:template>

  <xsl:template match="tei:titleStmt">
    <div class="div1">
	  <xsl:variable name="id" select="//tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno"/>
	  <xsl:variable name="title" select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
    <img class="titleImg" src="{$id}titleblack.png" alt="{$title}"/>
    <div class="credits">
      <p>Folger Shakespeare Library</p>
      <p><a href="http://www.folgerdigitaltexts.org">http://www.folgerdigitaltexts.org</a></p>
    </div>
     <hr/>
    </div>
  </xsl:template>

  <xsl:template match="tei:particDesc">
    <div class="page div1">
     <a name="castlist"/>
     <div class="charHeader">Characters in the Play</div>
     <div id="optionsBox">
	     <input type="checkbox" class="optionsCheckbox" id="selectAll"/>
	     <span id="optionsBoxText">select all/none</span> 
     </div> 
     <xsl:apply-templates/>
     <hr/>
   </div>
  </xsl:template>

  <xsl:template match="tei:particDesc/tei:listPerson">
    <p><div><xsl:apply-templates/></div></p>
  </xsl:template>
  <xsl:template match="tei:listPerson[tei:head]">
    <div class="castDiv">
	    <div class="castDiv">
		    <xsl:apply-templates/>
	    </div>
    <xsl:choose>
    <xsl:when test="count(tei:person/tei:persName)+count(tei:personGrp/tei:p) = 0">
      <p><xsl:value-of select="./tei:head"/></p>
    </xsl:when>
    <xsl:otherwise>
    <xsl:variable name="height" select="(count(tei:person/tei:persName)+count(tei:personGrp/tei:p))*20"/>
    <div class="bracketDiv" style="height:{$height}px;">
      <img src="bracket.png" style="height:100%;width:100%" alt=""/>
    </div>
    <div class="castDiv" style="line-height:{$height}px">
      <span class="italic"><xsl:value-of select="./tei:head"/></span>
    </div>
    </xsl:otherwise>
    </xsl:choose>
    </div>
    <div style="clear:both;"></div>
  </xsl:template>
  <xsl:template match="tei:listPerson/tei:head">
  </xsl:template>
  <xsl:template match="tei:particDesc//tei:person[tei:persName]">
	  <div style="line-height:20px;">
		  <input type="checkbox" class="charCheckbox">
			  <xsl:attribute name="id"> 
				  <xsl:value-of select="@*"/> 
			  </xsl:attribute> 
		  </input> 
		  <xsl:apply-templates/>
	  <br/>
	  </div>
  </xsl:template>
  <xsl:template match="tei:particDesc//tei:personGrp[tei:p]">
	  <div style="line-height:20px;">
		  <input type="checkbox" class="charCheckbox">
			  <xsl:attribute name="id"> 
				  <xsl:value-of select="@*"/> 
			  </xsl:attribute> 
		  </input> 
		  <xsl:apply-templates/>
	  <br/></div>
  </xsl:template>
  <xsl:template match="tei:particDesc//tei:name|tei:particDesc//tei:roleName">
	  <span class="castName"><xsl:value-of select="."/></span>
  </xsl:template>
  <xsl:template match="tei:particDesc//tei:state">
    <span><xsl:text>, </xsl:text><xsl:value-of select="."/></span>
  </xsl:template>
  <xsl:template match="tei:sex|tei:death">
  </xsl:template>

  <xsl:template match="tei:lb">
     <br/>
  </xsl:template>

  <xsl:key name="actPage" match="tei:text/tei:body/tei:pb" use="substring(@spanTo,2)"/> 
  <xsl:key name="altRdg" match="tei:app[@from]" use="substring(@from,2)"/> 
  <xsl:key name="folger1" match="tei:div/tei:ab/tei:ptr[@type='emendation'][@ana='#folger'] | tei:rdg[contains(@wit,$rdg)]/tei:ptr[@type='emendation'][@ana='#folger']" use="substring(@target,2,8)"/> 
  <xsl:key name="folger2" match="tei:div/tei:ab/tei:ptr[@type='emendation'][@ana='#folger'] | tei:rdg[contains(@wit,$rdg)]/tei:ptr[@type='emendation'][@ana='#folger']" use="substring(@target,string-length(@target)-7)"/> 
  <xsl:key name="texta1" match="tei:div/tei:ab/tei:ptr[@type='emendation'][@ana='#texta'] | tei:rdg[contains(@wit,$rdg)]/tei:ptr[@type='emendation'][@ana='#texta']" use="substring(@target,2,8)"/> 
  <xsl:key name="texta2" match="tei:div/tei:ab/tei:ptr[@type='emendation'][@ana='#texta'] | tei:rdg[contains(@wit,$rdg)]/tei:ptr[@type='emendation'][@ana='#texta']" use="substring(@target,string-length(@target)-7)"/> 
  <xsl:key name="textb1" match="tei:div/tei:ab/tei:ptr[@type='emendation'][@ana='#textb'] | tei:rdg[contains(@wit,$rdg)]/tei:ptr[@type='emendation'][@ana='#textb']" use="substring(@target,2,8)"/> 
  <xsl:key name="textb2" match="tei:div/tei:ab/tei:ptr[@type='emendation'][@ana='#textb'] | tei:rdg[contains(@wit,$rdg)]/tei:ptr[@type='emendation'][@ana='#textb']" use="substring(@target,string-length(@target)-7)"/> 

  <xsl:template match="tei:pb">
    <a name="p{@n}"/>
    <hr class="noprint pageBorder"/>
    <div class="pageHeading">
      <div class="pageNbr">
        <xsl:value-of select="@n"/>
      </div>
      <div class="pageTitle">
        <xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
      </div>
      <div class="pageDesc">
        <xsl:value-of select="following-sibling::tei:fw"/>
      </div>
      <br/>
    </div>    
  </xsl:template>

  <xsl:template match="tei:text/tei:body/tei:pb">
    <a name="p{@n}"/>
  </xsl:template>
  <xsl:template match="tei:fw[@type='header']"></xsl:template>
  <xsl:template match="tei:milestone[@unit='page'][key('actPage',@xml:id)]">
        <div class="actFooter">
          <xsl:value-of select="@n"/>
        </div>
  </xsl:template>

  <xsl:template match="tei:div1">
     <a name="line-{@n}.0.0"/>
     <div id="dialogOnly"> 
	     <h2>Raw Dialog Output</h2> 
	     <p>This is the raw dialog from the characters selected above. Copy and paste this into a text file if you want. The line numbers will not show up in your copied text.</p> 
     </div> 
     <div class="div1 act"><xsl:apply-templates/></div>
     <hr/>
  </xsl:template>
  <xsl:template match="tei:div1/tei:head">
     <div class="page actHeader"><xsl:apply-templates/></div>
  </xsl:template>
  <!--
  <xsl:template match="tei:div1[1]/tei:head">
     <div class="actHeader"><xsl:apply-templates/></div>
  </xsl:template>
  -->
  <xsl:template match="tei:div2">
     <a name="line-{../@n}.{@n}.0"/>
     <div class="div2"><xsl:apply-templates/><br/><br/><br/></div>
  </xsl:template>
  <xsl:template match="tei:div2/tei:head">
     <div class="sceneHeader"><xsl:apply-templates/></div>
  </xsl:template>
  <xsl:template match="tei:floatingText//tei:head">
     <xsl:variable name="class" select="translate(@rend,',',' ')" />
     <div class="centered italic {$class}"><xsl:apply-templates/></div>
  </xsl:template>
  <xsl:template match="tei:floatingText//tei:head[@rend='inline']">
     <span class="italic"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:speaker">
     <xsl:variable name="class" select="translate(@rend,',',' ')" />
     <span class="speaker {$class}"><xsl:apply-templates/></span>
  </xsl:template>

  <!--I added this--> 
  <xsl:template match="tei:sp/tei:ab">
	  <span class="dialog"> 
		  <xsl:attribute name="id"> 
			  <xsl:value-of select="substring(../@who, 2)"/>
		  </xsl:attribute> 
		  <xsl:apply-templates/> 
	  </span><br/>
  </xsl:template>



  <xsl:template match="tei:w|tei:c|tei:pc|tei:w/tei:seg|tei:anchor">
	  <xsl:variable name="class" select="translate(@rend,',',' ')" />

	  <span id="{@xml:id}" title="{@n}" class="{$class}">

		  <xsl:if test="key('textb1',@xml:id)">
			  <img src="ltxb.png" class="imgTxt" alt="{$textb}" title="{$textb}"/>
		  </xsl:if>
		  <xsl:if test="key('texta1',@xml:id)">
			  <img src="ltxa.png" class="imgTxt" alt="{$texta}" title="{$texta}"/>
		  </xsl:if>
		  <xsl:if test="key('folger1',@xml:id)">
			  <img src="lfsl.png" class="imgFSL" alt="Folger emendation" title="Folger emendation"/>
		  </xsl:if>

      <xsl:if test="(ancestor::tei:q[1]//tei:w|ancestor::tei:q[1]//tei:pc)[1]/@xml:id = ./@xml:id and (not(ancestor::tei:q[2]) or (ancestor::tei:q[2]//tei:w|ancestor::tei:q[2]//tei:pc)[1]/@xml:id = ./@xml:id)">
        <xsl:text>&#8220;</xsl:text>
      </xsl:if>
      <xsl:if test="(ancestor::tei:q[1]//tei:w|ancestor::tei:q[1]//tei:pc)[1]/@xml:id = ./@xml:id and ancestor::tei:q[2]">
        <xsl:text>&#8216;</xsl:text>
      </xsl:if>

      <xsl:call-template name="showRdg"/>

      <xsl:if test="(ancestor::tei:q[1]//tei:w|ancestor::tei:q[1]//tei:pc)[last()]/@xml:id = ./@xml:id and ancestor::tei:q[2]">
        <xsl:text>&#8217;</xsl:text>
      </xsl:if>
      <xsl:if test="(ancestor::tei:q[1]//tei:w|ancestor::tei:q[1]//tei:pc)[last()]/@xml:id = ./@xml:id and (not(ancestor::tei:q[2]) or (ancestor::tei:q[2]//tei:w|ancestor::tei:q[2]//tei:pc)[last()]/@xml:id = ./@xml:id)">
        <xsl:text>&#8221;</xsl:text>
      </xsl:if>

      <xsl:if test="key('folger2',@xml:id)">
        <img src="rfsl.png" class="imgFSL" alt="Folger emendation" title="Folger emendation"/>
      </xsl:if>
      <xsl:if test="key('texta2',@xml:id)">
        <img src="rtxa.png" class="imgTxt" alt="{$texta}" title="{$texta}"/>
      </xsl:if>
      <xsl:if test="key('textb2',@xml:id)">
        <img src="rtxb.png" class="imgTxt" alt="{$textb}" title="{$textb}"/>
      </xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="tei:c">
    <xsl:variable name="class" select="translate(@rend,',',' ')" />
    <xsl:choose>
    <xsl:when test="key('altRdg',@xml:id)">
      <xsl:variable name="xmlId" select="@xml:id"/>
      <xsl:choose>
      <xsl:when test="//tei:app[contains(@from,$xmlId)]/tei:rdg[contains(@wit,$rdg)]">
        <xsl:apply-templates select="//tei:app[contains(@from,$xmlId)]/tei:rdg[contains(@wit,$rdg)]"/>
      </xsl:when>
      <xsl:otherwise>
      <span title="{./@n}" class="{$class}"><xsl:value-of select="translate(.,' ','&#160;')"/></span>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <span title="{./@n}" class="{$class}"><xsl:value-of select="translate(.,' ','&#160;')"/></span>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="showTLN">
    <xsl:variable name="ftln" select="substring-after(@xml:id,'ftln-')"/>
    <a class="hidden" name="{@xml:id}">FTLN</a>
    <a class="hidden" name="line-{@n}">LINE</a>
    <span class="ftln" name="ftln_{$ftln}">FTLN <xsl:value-of select="substring-after(@xml:id,'ftln-')"/></span>
    <xsl:choose>
    <xsl:when test="number(substring-after(substring-after(@n,'.'),'.'))">
    <xsl:variable name="lineNbr" select="number(substring-after(substring-after(@n,'.'),'.'))"/>
    <xsl:if test="($lineNbr mod 5) = 0">
      <span class="lineNbr" name="line_{@n}">
      <xsl:value-of select="$lineNbr"/>
      </span>
    </xsl:if>
    </xsl:when>
    <xsl:when test="number(substring-after(@n,'.'))">
    <xsl:variable name="lineNbr" select="number(substring-after(@n,'.'))"/>
    <xsl:if test="($lineNbr mod 5) = 0">
      <span class="lineNbr" name="line_{@n}">
      <xsl:value-of select="$lineNbr"/>
      </span>
    </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <a name="line-{@n}">No line</a>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="showRdg">
    <xsl:choose>
    <xsl:when test="key('altRdg',@xml:id)">
      <xsl:variable name="xmlId" select="@xml:id"/>
      <xsl:choose>
      <xsl:when test="//tei:app[contains(@from,$xmlId)]/tei:rdg[contains(@wit,$rdg)]">
        <xsl:apply-templates select="//tei:app[contains(@from,$xmlId)]/tei:rdg[contains(@wit,$rdg)]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:stage">
    <xsl:variable name="lineNbr" select="(substring-after(@n,'SD '))"/>
    <a class="hidden" name="line-SD{$lineNbr}">SD</a>
    <xsl:variable name="class" select="translate(@rend,',',' ')" />
    <xsl:choose>
      <xsl:when test="starts-with(./*/text(),',')">
      <span class="stage inline {$class}"><xsl:apply-templates/></span>
    </xsl:when>
    <xsl:otherwise>
      <span class="stage right {$class}"><xsl:apply-templates/></span>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:stage[@type='entrance']">
     <xsl:variable name="lineNbr" select="(substring-after(@n,'SD '))"/>
     <a class="hidden" name="line-SD{$lineNbr}">SD</a>
     <xsl:variable name="class" select="translate(@rend,',',' ')" />
     <span class="stage centered {$class}"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:stage[contains('delivery,location,modifier',@type)]">
     <xsl:variable name="lineNbr" select="(substring-after(@n,'SD '))"/>
     <a class="hidden" name="line-SD{$lineNbr}">SD</a>
     <xsl:variable name="class" select="translate(@rend,',',' ')" />
     <span class="stage {$class}"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:stage[@type='dumbshow']">
     <xsl:variable name="lineNbr" select="(substring-after(@n,'SD '))"/>
     <a class="hidden" name="line-SD{$lineNbr}">SD</a>
     <xsl:variable name="class" select="translate(@rend,',',' ')" />
     <span class="stage {$class}"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:stage[contains(@rend,'inline')]">
     <xsl:variable name="lineNbr" select="(substring-after(@n,'SD '))"/>
     <a class="hidden" name="line-SD{$lineNbr}">SD</a>
     <xsl:variable name="class" select="translate(@rend,',',' ')" />
     <span class="stage {$class}"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:stage[contains(@rend,'centered')]">
     <xsl:variable name="lineNbr" select="(substring-after(@n,'SD '))"/>
     <a class="hidden" name="line-SD{$lineNbr}">SD</a>
     <xsl:variable name="class" select="translate(@rend,',',' ')" />
     <span class="stage centered {$class}"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:stage[@type='mixed']">
    <xsl:variable name="lineNbr" select="(substring-after(@n,'SD '))"/>
    <a class="hidden" name="line-SD{$lineNbr}">SD</a>
    <xsl:variable name="class" select="translate(@rend,',',' ')" />
    <xsl:choose>
      <xsl:when test="descendant::tei:stage[@type='entrance']">
      <span class="stage centered {$class}"><xsl:apply-templates/></span>
    </xsl:when>
    <xsl:when test="@rend='inline'">
      <span class="stage {$class}"><xsl:apply-templates/></span>
    </xsl:when>
    <xsl:otherwise>
      <span class="stage right {$class}"><xsl:apply-templates/></span>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:stage//tei:stage">
    <xsl:variable name="class" select="translate(@rend,',',' ')" />
    <span class="stage {$class}"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:stage[@rend='inline']//tei:lb">
    <br/><span class="alignment indentProse">&#160;</span>
  </xsl:template>


  <xsl:template match="tei:seg[@type][contains('song,verse,letter',@type)]">
    <xsl:variable name="class" select="translate(@rend,',',' ')" />
    <span id="{@xml:id}" class="italic {$class}"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:seg[@type='poem']">
    <xsl:variable name="class" select="translate(@rend,',',' ')" />
    <span id="{@xml:id}" class="{$class}"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:seg[@type='letter'][@subtype='closing']">
    <xsl:variable name="class" select="translate(@rend,',',' ')" />
    <span class="closing {$class}"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:seg[@type='letter'][@subtype='signature']">
    <xsl:variable name="class" select="translate(@rend,',',' ')" />
    <span class="right {$class}"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:seg[@type='letter'][@subtype='closing']/tei:seg[@type='letter'][@subtype='signature']">
    <xsl:variable name="class" select="translate(@rend,',',' ')" />
    <span class="closingSig {$class}"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:seg[@type='dramatic']">
    <span class="italic"><xsl:apply-templates/></span>
  </xsl:template>


  <xsl:template match="tei:ab[not(@type)][@rend]">
     <xsl:variable name="class" select="translate(@rend,',',' ')" />
     <span class="{$class}"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:hi">
     <xsl:variable name="class" select="translate(@rend,',',' ')" />
     <span class="{$class}"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:foreign">
     <span class="italic"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:name">
     <span class="italic"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:title[@rend='italic']">
     <span class="italic"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:title[@rend='quotes']">
     <xsl:text>&#8220;</xsl:text><xsl:apply-templates/><xsl:text>&#8221;</xsl:text>
  </xsl:template>

  <xsl:template match="tei:gap">
     <xsl:text>&#8230;</xsl:text>
  </xsl:template>

  <xsl:template match="tei:w//tei:q">
     <xsl:text>&#8220;</xsl:text><xsl:apply-templates/><xsl:text>&#8221;</xsl:text>
  </xsl:template>


  <xsl:template match="tei:ptr[@type='stanza'][@ana='#quatrain'][@n='2' or @n='4']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#AAb'][@n='1' or @n='2']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aaB'][@n='3']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aBb'][@n='2']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#AAbCCb'][@n='1' or @n='2' or @n='4' or @n='5']">
    <span class="alignment" style="padding-left:25px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#AAbCCb'][@n='3' or @n='6']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aA'][@n='2']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aBcB'][@n='2' or @n='4']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#AAbC'][@n='1' or @n='2' or @n='4']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#AAbbA'][@n='1' or @n='2' or @n='5']">
    <span class="alignment" style="padding-left:25px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aaBBa'][@n='3' or @n='4']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aaBBc'][@n='3' or @n='4']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#abCCb'][@n='3' or @n='4']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aaBaaB'][@n='3' or @n='6']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aaBccB'][@n='3' or @n='6']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aBaBcC'][@n='2' or @n='4' or @n='6']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aBBaCC'][@n='2' or @n='3' or @n='5' or @n='6']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aBaBccB'][@n='2' or @n='4']">
    <span class="alignment" style="padding-left:30px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aBaBccB'][@n='3' or @n='7']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#AAaBBaa'][@n='1' or @n='2' or @n='4' or @n='5']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aabbCCDEED'][@n='5' or @n='6' or @n='8' or @n='9']">
    <span class="alignment" style="padding-left:10px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aabbCCDEED'][@n='7' or @n='10']">
    <span class="alignment" style="padding-left:20px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#AABBbCCDDb'][not(@n='5' or @n='10')]">
    <span class="alignment" style="padding-left:20px;">&#160;</span>
  </xsl:template>
  <xsl:template match="tei:ptr[@type='stanza'][@ana='#aaaBcccB'][@n='4' or @n='8']">
    <span class="alignment" style="padding-left:20px;">&#160;</span>
  </xsl:template>

  <!--
  <xsl:template match="//*[key('altRdg',@xml:id)]">
  -->
  <xsl:template match="tei:ptr[@type='stanza'][key('altRdg',@xml:id)]">
    <xsl:choose>
    <xsl:when test="$rdg = 'lemma'">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="key('altRdg',@xml:id)">
      <xsl:variable name="xmlId" select="@xml:id"/>
      <xsl:apply-templates select="//tei:app[contains(@from,$xmlId)]/tei:rdg[contains(@wit,$rdg)]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  Test whether stage direction words appear in a line <join>
  <xsl:template match="tei:stage/*">
    <xsl:variable name="stgId" select="@xml:id"/>
    <xsl:choose>
    <xsl:when test="//tei:join[contains(@target,$stgId)]">
      <span class="red" style="border:10px solid red;"><xsl:apply-templates/></span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  -->

  <xsl:template match="tei:ab">
      <span class="indentInline">&#160;</span>
      <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tei:join">
   <xsl:call-template name="showTLN"/>
  </xsl:template>

  <xsl:template match="tei:join">
    <xsl:call-template name="showTLN"/>

    <xsl:if test="ancestor::tei:seg[@type][contains('song,poem',@type)] and not(contains(ancestor::tei:seg[1]/@rend,'inline')) and not(contains(ancestor::tei:seg[1]/@rend,'indentAs'))">
      <span id="seg{@xml:id}" class="alignment" style="padding-left:10px;">&#160;</span>
      <xsl:if test="ancestor::tei:seg[@type][contains('song,poem',@type)][not(@prev)]">
        <script>alignSegsCmd += "alignSegs('seg<xsl:value-of select="@xml:id"/>','seg<xsl:value-of select="(ancestor::tei:seg[1]//tei:join)[1]/@xml:id"/>','<xsl:value-of select="ancestor::tei:seg[1]/@xml:id"/>');";</script>
      </xsl:if>
      <xsl:if test="ancestor::tei:seg[@type][contains('song,poem',@type)][@prev]">
        <script>alignSegsCmd += "alignSegs('seg<xsl:value-of select="@xml:id"/>','seg<xsl:value-of select="(preceding::tei:seg[not(@prev)][1]//tei:join)[1]/@xml:id"/>','');";</script>
      </xsl:if>
    </xsl:if>

     <xsl:choose>
       <xsl:when test="ancestor::tei:stage[@type='dumbshow']">
       </xsl:when>
       <xsl:when test="contains(@rend,'inline')">
       </xsl:when>
       <xsl:when test="contains(@rend,'align')">
         <span id="c{@xml:id}" class="alignment indentSplit">&#160;</span>
         <xsl:variable name="prevId" select="substring(@prev,2)" />
         <xsl:variable name="prevTarget" select="substring-before(substring-after(@rend,'align{'),'}')"/>
         <xsl:variable name="lastId" select="substring-before(substring-after(@rend,'align{'),'}')"/>
         <script>alignSplitLinesCmd += "alignSplitLines('<xsl:value-of select="concat('c',@xml:id)"/>','<xsl:value-of select="$lastId"/>','B');";</script>
       </xsl:when>
       <xsl:when test="not(@prev) and not((preceding::tei:lb[1]/following::tei:w[1]) = following::tei:w[1])">
       </xsl:when>
       <xsl:when test="@ana='#prose'">
         <span class="alignment indentProse">&#160;</span>
       </xsl:when>
       <xsl:when test="@ana='#short'">
         <span class="alignment indentVerse">&#160;</span>
       </xsl:when>
       <xsl:when test="@prev">
           <xsl:choose>
             <xsl:when test="count(. | (ancestor::tei:ab[1]//tei:join)[1]) = 1 or preceding::tei:w[1]/@xml:id = preceding::tei:stage[not(@type='delivery')][1]/tei:w[last()]/@xml:id">
               <span id="c{@xml:id}" class="alignment indentSplit">&#160;</span>
               <xsl:variable name="prevId" select="substring(@prev,2)" />
               <xsl:variable name="prevTarget" select="//tei:join[@xml:id=$prevId]/@target"/>
               <xsl:variable name="lastId" select="substring($prevTarget,string-length($prevTarget)-7)"/>
               <script>alignSplitLinesCmd += "alignSplitLines('<xsl:value-of select="concat('c',@xml:id)"/>','<xsl:value-of select="$lastId"/>','E');";</script>
             </xsl:when>
             <xsl:otherwise>
               <span class="alignment indentRunOn">&#160;</span>
             </xsl:otherwise>
           </xsl:choose>
       </xsl:when>
       <xsl:when test="ancestor::tei:seg[@type][contains('song,poem',@type)] and not(contains(ancestor::tei:seg[1]/@rend,'indentAs'))">
       </xsl:when>
       <xsl:when test="@ana='#verse'">
         <span class="alignment indentVerse">&#160;</span>
       </xsl:when>
       <xsl:otherwise>
       </xsl:otherwise>
     </xsl:choose>
     <xsl:if test="contains(@rend,'indent')">
       <span class="alignment indent">&#160;</span>
     </xsl:if>
  </xsl:template>

</xsl:stylesheet>
