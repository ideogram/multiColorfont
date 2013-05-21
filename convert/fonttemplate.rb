require 'rubygems'
require 'builder'


def product_xml
  alphabet = [" "] 	#at the very least, we need a space character
  alphabet = alphabet +  ('A'..'Z').to_a
  #alphabet = alphabet +  ('a'..'z').to_a
  #alphabet = alphabet +  ('0'..'9').to_a  
  #alphabet = alphabet +  "!?().,;:".each_char.to_a 
  #alphabet = alphabet +  "{}[]%&*@-+|/".each_char.to_a 
  #alphabet = alphabet +  "-¡¢£¤¥¦§¨©ª«¬®¯°±²³´µ¶·¸¹º»¼½¾¿×ˆ˜–—‘’‚“”„†‡•…‰‹›$€™".each_char.to_a 
  #alphabet = alphabet +  "ßÀàÁáÂâÃãÄäÅåÆæÇçÈèÉéÊêËëÌìÍíÎîÏïÐðÑñÒòÓóÔôÕõÖö÷ØøÙùÚúÛûÜüÝýÞþŸÿŒœŠšŽžƒ".each_char.to_a
  
  xml = Builder::XmlMarkup.new( :indent => 2 )
  xml.instruct! :xml, :encoding => "ASCII"
  xml.declare! :DOCTYPE, :svg, :PUBLIC, "-//W3C//DTD SVG 1.1//EN" , "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
  xml.svg(
	  	:"xmlns:inkscape"=>"http://www.inkscape.org/namespaces/inkscape",
	  	:"xmlns:sodipodi"=>"http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd", 
	  	:width=>"512", 
	  	:height=>"1024", 
	  	:"inkscape:dummy1"=>"dummy",
	  	:"sodipodi:dummy2"=>"dummy") do
	xml.metadata("Created by")
	xml.tag!("sodipodi:namedview") do
		xml.tag!("sodipodi:guide", :orientation=>"0,1", :position=>"-256,1024", :id=>"ascent")
		xml.tag!("sodipodi:guide", :orientation=>"0,1", :position=>"-256,-256", :id=>"descent")
		xml.tag!("sodipodi:guide", :orientation=>"0,1", :position=>"-256,512", :id=>"x-height")
		xml.tag!("sodipodi:guide", :orientation=>"0,1", :position=>"-256,768", :id=>"cap-height")
		xml.tag!("sodipodi:guide", :orientation=>"0,1", :position=>"-256,0", :id=>"baseline")
		xml.tag!("sodipodi:guide", :orientation=>"1,0", :position=>"512,-256", :id=>"horiz-adv-x")

	end
	alphabet.each.reverse_each do|i|
		xml.g(
				:"inkscape:label"=>i, 
				:transform=>"scale(1,-1) translate(0,-1024)", 
				:"inkscape:groupmode"=>"layer", 
				:display=>"none",
				:id=>i) do 
			xml.rect(:x=>512, :y=>-256, :width=>32, :height=>1280, :style=>"fill:#ffc0ff;", :class=>"charwidth")
		end
	end
  end
end

puts product_xml