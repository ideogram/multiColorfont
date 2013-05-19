require 'rubygems'
require 'builder'
require 'nokogiri'
require 'open-uri'


#Collect command-line arguments
$input = ARGV[0]

if $input.nil?
	puts "Please, give the location of a .template.SVG-file as the argument."
	abort
end if

$output =  $input.slice(0..($input.index('.'))) + "font.svg"

#Open the INKSCAPE template as an XML document to retrieve it's content
$doc = Nokogiri::HTML(open($input))

#Okay, let's go!
$stdout.sync = true

puts "Converting Inkscape Layers to GLYPHS"

#Read out some metrics and use defaults if these are not given
$ascent = $doc.css('#ascent')[0]["position"].split(",")[1]
$descent = $doc.css('#descent')[0]["position"].split(",")[1] 
$x_height = $doc.css('#x-height')[0]["position"].split(",")[1] 
$cap_height = $doc.css('#cap-height')[0]["position"].split(",")[1] 
$horiz_adv_x = $doc.css('#horiz-adv-x')[0]["position"].split(",")[0]
$units_per_em = ($ascent.to_i - $descent.to_i).to_s

def product_xml  
  #Create a XML document for out output
  xml = Builder::XmlMarkup.new( :indent => 2 )
  xml.instruct! :xml, :encoding => "ASCII"
  xml.declare! :DOCTYPE, :svg, :PUBLIC, "-//W3C//DTD SVG 1.1//EN" , "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
  
  xml.svg do 
    xml.metadata("Created by")
    xml.defs do
      xml.font(:"horiz-adv-x"=>$horiz_adv_x) do
        xml.tag!("font-face", :ascent=>$ascent, :descent=>$descent, :"units-per-em"=>$units_per_em, :"x-height"=>$x_height, :"cap_height"=>$cap_height)
        xml.tag!("missing-glyph", :horiz_adv_x=>($horiz_adv_x.to_i / 2).to_i )
        $doc.css("g").each do |g|
          puts g['inkscape:label'].green
          w = g.css("rect.charwidth").length > 0 ? g.css("rect.charwidth")[0]["x"] : $horiz_adv_x.to_s
          xml.glyph(:unicode=>g['inkscape:label'],:"horiz-adv-x"=>w, :"glyph-name"=>g['inkscape:label']) do
            g.css("path").each do |path|
              xml.path(:d=>path["d"], :transform=>"scale(1,-1) translate(0,-" + $ascent + ")")    
            end #path   
          end #glyph
        end #g

      end #font
    end #defs
  end #svg
end #document

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def pink
    colorize(35)
  end
end

File.open($output, 'w') {|f| f.write(product_xml) }

#TODO: save ID between conversions
#TODO: display characters decently in console
#TODO: check units-per-em vs height vs ascent

