(function( $ ){
   $.fn.multiColorFont = function(args){

    var id = random(1000000);
    var styles = args.styles;
    var target = this;

    $_font = $("body").append('<object data="' + args.url  + '" type="image/svg+xml" id="' + id + '" width="100%" height="100%"></object>');

    // Typographic measures, asume some default values in case nothing is declared
    var unitsPerEm = 2048;
    var horizAdvX = 512;
    var ascent = 1024;
    var descent = 512;

    // Global variables
    var font = document.getElementById( id );
    var glyphs = new Array();

    // Run only after the SVG font has been loaded:
    font.addEventListener("load",function(){
        var svgDoc = font.contentDocument; 
        
        //get typographic measures
        elem_font =           svgDoc.getElementsByTagName("font")[0]; 
        elem_fontFace =       svgDoc.getElementsByTagName("font-face")[0]; 
        ascent =              parseInt(elem_fontFace.getAttribute("ascent"));
        descent =             parseInt(elem_fontFace.getAttribute("descent"));
        horizAdvX =           parseInt(elem_font.getAttribute("horiz-adv-x"));
        unitsPerEm =          parseInt(elem_fontFace.getAttribute("units-per-em"));

        //get collection of glyphs
        var elem_glyphs =         svgDoc.getElementsByTagName("glyph");
        
        for (var i=0; i<elem_glyphs.length; i++){
          glyphs[i] = new Array();

          array_paths = new Array();

          //  try to get path-data from 'd'-attribute in the glyph-element
          if ( elem_glyphs[i].getAttribute("d") ){
            array_paths.push(  elem_glyphs[i].getAttribute("d")  ); 
          }

          // try to get path-data from 'd'-attribute in path elements
          elem_paths = elem_glyphs[i].getElementsByTagName("path");  

          for (var j=0; j<elem_paths.length; j++){
            array_paths.push( elem_paths[j].getAttribute("d")  );
          }

          // set for each glyph the unicode and the horizontal advance
          glyphs[i]["unicode"]  =    elem_glyphs[i].getAttribute("unicode");
          glyphs[i]["horizAdvX"]  =    elem_glyphs[i].getAttribute("horiz-adv-x");
          glyphs[i]["paths"]  =    array_paths;
        }

        draw(target);
      
    },false);

    function draw(target){

      target.each(function(){

        $_me = $(this);

        // create drawing canvas        
        var paper = Raphael(
          $_me.position().left, 
          $_me.position().top, 
          $_me.width(), 
          $_me.height() 
        );  

        // try to copy all styling
        var style = css($_me);
        $(paper).css(style);

        var scale = parseInt(  $_me.css("font-size")  ) / unitsPerEm;

        var line = $(this).html();

        var xpos=0;

        var path = new Array();

        for(i=0; i<line.length; i++) {
          charachter =  line.charAt(i);
          index = returnIndex(glyphs, charachter);

          if ( index != null ) {
          
          	u = glyphs[ index ]['unicode']; 
          	
      		  path[i] = new Array();
      		
        		for (pen=0; pen<glyphs[ index ]['paths'].length; pen++){
        		  d = glyphs[ index ][ 'paths' ][ pen ];                
        		  path[i][pen] = paper.path( d );      
        		  path[i][pen].transform( "S" + scale + "," + -scale + ",0,0 T" + xpos*scale + "," + ((unitsPerEm+descent)*scale)  );

              // pick a style to apply on each path and assing the attributes to it (typically fill and stroke)
              var currentStyle = styles[ pen % styles.length   ];
              //var currentStyle = styles[ random( styles.length)   ];
              
              for (var attribute in currentStyle){
                path[i][pen].attr(attribute, currentStyle[attribute]);
              }
        		}
          
        		if ( glyphs[ index ]['horizAdvX'] ){
        		  xpos += parseInt( glyphs[ index ]['horizAdvX'] );
        		} else {
              
              xpos += horizAdvX;
            }
      	  } 
        }
      });

      $_me.css("opacity","0.0");
      $_me.css("z-index","1000");
      //$_me.appendTo("body");
    }

    function returnIndex(glyphs, character) {
      result = null;
      
      for (var i = 0; i < glyphs.length; i++) {
        if (glyphs[i].unicode == character ) {        
            result = i;
            break;        
        }
      }  
      
      return result;
    }

    function random(ceiling){
      return Math.floor((Math.random()*ceiling)); 
    }

    // Thanks http://stackoverflow.com/users/342275/marknadal
    function css(a){
      var sheets = document.styleSheets, o = {};
      for(var i in sheets) {
          var rules = sheets[i].rules || sheets[i].cssRules;
          for(var r in rules) {
              if(a.is(rules[r].selectorText)) {
                  o = $.extend(o, css2json(rules[r].style), css2json(a.attr('style')));
              }
          }
      }
      return o;
    }

    // Thanks http://stackoverflow.com/users/342275/marknadal
    function css2json(css){
      var s = {};
      if(!css) return s;
      if(css instanceof CSSStyleDeclaration) {
          for(var i in css) {
              if((css[i]).toLowerCase) {
                  s[(css[i]).toLowerCase()] = (css[css[i]]);
              }
          }
      } else if(typeof css == "string") {
          css = css.split("; ");          
          for (var i in css) {
              var l = css[i].split(": ");
              s[l[0].toLowerCase()] = (l[1]);
          };
      }
      return s;
    }

  }


})( jQuery );
