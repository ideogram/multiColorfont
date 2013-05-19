require 'rubygems'
require 'builder'
require 'nokogiri'
require 'open-uri'

#Collect command-line arguments
$input = ARGV[0]

if $input.nil?
	puts ""
	puts "Please, give the location of a SVG-font file as the argument."
	puts ""
	abort
end if

if $input[-4,4] != ".svg"
	puts ""
	puts "We're sorry. The file extension is not SVG."
	puts "This script only accepts SVG fonts. Try to convert the font to SVG using, for example, FontForge or use the SVG font from a webfont collection"
	puts ""
	abort
end if

$output =  $input.slice(0..($input.index('.'))) + "template.svg"

#Open the SVG font as an XML document to retrieve it's content
$doc = Nokogiri::HTML(open($input))

#Okay, let's go!
$stdout.sync = true
puts "Converting GLYPHS to Inkscape Layers:..."

#Read out some metrics and use defaults if these are not given
$ascent = 		$doc.css('font-face')[0]["ascent"] ? $doc.css('font-face')[0]["ascent"] : 1024
$descent = 		$doc.css('font-face')[0]["descent"] ? $doc.css('font-face')[0]["descent"] : -256
$horiz_adv_x = 	$doc.css('font')[0]["horiz-adv-x"] ? $doc.css('font')[0]["horiz-adv-x"] : ($ascent/2).to_s
$units_per_em = $doc.css('font-face')[0]["units-per-em"] ? $doc.css('font-face')[0]["units-per-em"] : $ascent + $descent
$x_height = 	$doc.css('font-face')[0]["x-height"] ? $doc.css('font-face')[0]["x-height"] : ($ascent/2).to_s
$cap_height = 	$doc.css('font-face')[0]["cap-height"] ? $doc.css('font-face')[0]["cap-height"] : ($ascent*0.75).to_s


def product_xml  
  #Create a XML document for out output
  xml = Builder::XmlMarkup.new( :indent => 2 )
  xml.instruct! :xml, :encoding => "ASCII"
  xml.declare! :DOCTYPE, :svg, :PUBLIC, "-//W3C//DTD SVG 1.1//EN" , "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
  

  xml.svg(:"xmlns:inkscape"=>"http://www.inkscape.org/namespaces/inkscape", :"xmlns:sodipodi"=>"http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd", :width=>$horiz_adv_x, :height=>$ascent, :"inkscape:dummy1"=>"dummy", :"sodipodi:dummy2"=>"dummy") do 
  	xml.metadata("Created by")
	
  	#Create guides to store ASCENDER and DESCENDER metrics
	xml.tag!("sodipodi:namedview") do
		xml.tag!("sodipodi:guide", :orientation=>"0,1", :position=>"-100," + $ascent, :id=>"ascent")
		xml.tag!("sodipodi:guide", :orientation=>"0,1", :position=>"-100," + $descent, :id=>"descent")
		xml.tag!("sodipodi:guide", :orientation=>"0,1", :position=>"-100," + $x_height, :id=>"x-height")
		xml.tag!("sodipodi:guide", :orientation=>"0,1", :position=>"-100," + $cap_height, :id=>"cap-height")				
		xml.tag!("sodipodi:guide", :orientation=>"0,1", :position=>"-100,0", :id=>"baseline")
		xml.tag!("sodipodi:guide", :orientation=>"1,0", :position=>$horiz_adv_x + ",-100", :id=>"horiz-adv-x")
	end
	
	#Iterate over all glyphs found in the source document
	$doc.css('glyph').each do |glyph|
		unless glyph["d"].nil? or glyph["d"] == ""
			
			#read the data from the d-attribute of the the glyph and store it in a path within a group
			xml.g( :"inkscape:label"=>glyph["unicode"], :transform=>"scale(1,-1) translate(0,-" + $ascent + ")", :"inkscape:groupmode"=>"layer", :display=>"none", :id=>glyph["unicode"]) do 
				glyph["d"].each("z").reverse_each do |d|
					xml.path(:d=>d)
				end
				x = glyph["horiz-adv-x"] ? glyph["horiz-adv-x"] : $horiz_adv_x
				
				#add a rectangle to 'store' the width of the character
				xml.rect(:x=>x, :y=>$descent, :width=>32, :height=>$ascent, :style=>"fill:#ffc0ff;", :class=>"charwidth")
			end

			#display the character we just converted as a means of dialogue box
			#putc glyph["unicode"]
		end	

	end

	puts ""
	puts "Done!"
	puts "Please, open the file in Inkscape and open the Layers-dialogue to edit the glyphs."

  end

end

File.open($output, 'w') {|f| f.write(product_xml) }