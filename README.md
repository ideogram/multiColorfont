multiColorfont
==============

a jQuery plugin for dynamic rendering of multi-colored fonts on webpages

See: http://ideogram.nl/multiColorfont/ for a demo.

See: https://github.com/ideogram/multiColorfont.git

### What does it do?

MultiColorFont displays fonts on a webpage rendered in multiple colors.

It turns dynamically (i.e.: on page-load) the content of HTML-element into
colored characters. So, your originally boring looking H2 in Arial will be
turned into a header made from multi-colored characters. How does it do that?

By using a jQuery-plugin and a specially prepared SVG-font in a CUFON-like manner.

Colorfont is a jQuery-plugin that uses the Raphael-library for writing to
vectors to the canvas. It makes use of a SVG-font that has been especially
prepared to contain multiple layers of colors. The colorfont-plugin adds this
font as an object to the DOM (in the same way Flash-objects ar added.) It is
then read out and written to a canvas on the same position as the the original
element.

### How do I use them on my page?

Download the attached zip-file. It contains:

* an example HTML document (index.html) that's pretty self-explanatory if you 
  have some HTML/jQuery knowledge.
* the multiColorfont-jQuery plugin (in the js folder)
* the jQuery and the Raphael.js libray
* some example SVG-fonts
* some ruby scripts to assist in the font making. (More on that later...)
* Choose your font and the colors in the arguments of the multiColor-function 
  call. Or: just look at the multiColorfont.html page and with some basic knowledge 
  of HTML, you'll be able to figure it out.

The multiColorfont.html-file should be the only place you'll need to adjust.
All the settings can be accessed from the jQuery-statements at the bottom.

Some things to keep in mind:
* The colorfont should on the same server as the page requesting it.
* The size the colorfont is rendered in, is determined by the CSS-font size of the original tag.

### How do I create my own SVG-multicolored-font?

Actually, that's the bottleneck at the time of writing this documentation.
I've made some scripts to assist in the making of it, but as they're very
experimental, you really could use some information on the concept behind 'my'
multicolored webfonts.

#### Step 1: understanding SVG-fonts

A SVG-multicolored font is a SVG-font. A SVG font, or for that matter: /any/
SVG-file, is a XML-file containing drawing-objects. In a SVG font, the data
(drawings) for every character are stored in glyph-elements. Lets's look at
this example from a SVG font; here the exlamation-character is defined:

	<glyph unicode="!" horiz-adv-x="559" d="M61 2v223h437v-223h-437zM61 338v1096h437v-1096h-437z" />

The actual drawing instructions are stored in the d-attribute.

Elsewhere in document, the 'font-metrics' are stored: things like x-height,
descender and ascender heights:

	<font horiz-adv-x="1163" >
	  <font-face units-per-em="2048" ascent="1638" descent="-410" />
	  <missing-glyph horiz-adv-x="614" />
	  (...)

#### Step 2: understanding multiColored SVG-fonts

To allow the drawing of colors in a character, we'll have the glyph made up of
different paths, that each can be applied a different style. (This happends
later on, when the font is drawn in the browser.) Let's look at the
excalamation-mark:

	<glyph horiz-adv-x="559" glyph-name="!" unicode="!">
	  <path (...) d="M61 338v1096h437v-1096h-437z"/>
	  <path (...) d="M61 2v223h437v-223h-437z"/>
	</glyph>

This separation of path-data into different path-elements is actually allowed
by the SVG-standard, so the document is still a valid SVG font. Fontforge, for
example, will be able to read it.

There's one backdraw on this approach, though. As long as we put the drawing
commands in d-attribute of the glyph, these commands are 'transalated' so
they'll end up in the right place according to the font metrics. These
translations are not done when we put these commands in the path-elements. So,
we need to add them ourselves. We need to mirror the path-element over the
y-axis and translate it upwards with the amount specified as 'ascender':

	<glyph horiz-adv-x="559" glyph-name="!" unicode="!">
		<path transform="scale(1,-1) translate(0,-1638)" d="M61 338v1096h437v-1096h-437z"/>
		<path transform="scale(1,-1) translate(0,-1638)" d="M61 2v223h437v-223h-437z"/>
	</glyph>

If you don't mind some hard manual labour, you now have enough information to
start making your own multiColorfont. You could download a SVG font from, for
example, <http://www.fontsquirrel.com> and re-work the path-data. However, I've tried
to create some tools to make it all a bit easier. More on that later...

#### Step 3: Creating your own multiColorfont

As far as I know, there's no program that allows for the creating of 'my'
multicolored fonts. I've chosen to use Inkscape and I've written a Ruby shell-
script that will turn the Inkscape layers from a SVG-drawing into the glyphs
of a SVG-font. It will also look for Inkscape guides to figure out the font
metrics. Basically, _this turns Inkscape in a font-editor!_

If you'd like to make your own font and want to start from skratch, you can
use a file called "myfirstfont.svg" to start working from. It has the right
guides and layers setup. All you need to do is fill the layers with the
characters you want. When you're done drawing, run the script template2font.rb
to turn your drawing in a svg-color font.

* when you're done creating your character, make sure all the objects are
turned into paths. All the parts of the character that should end up having
the same color, should be 'merged' or "united" into one single path. To be
sure, give them all a different color. 
* the actual colors are ignored by
jQuery plug-in. The color that each path within a glyph gets, is dependend on
the colors assigned in the arguments calling the jQuery plugin. * make sure
there are no groups in a glyph 
* Inkscape has the annoying tendecy to store
tranforsmations in a path. To get rid of them, select all paths and nudge them
back and forth once using the arrow-keys on the keyboard. 
* The pink rectangles should *not* be turned into paths. Position the right side of them
to the left-most part of your character. My script uses these rectangles to 
store the width of the character 
* To create the final svg font, invoke the
ruby script _template2font.rb_ with the name of your drawing as the only
argument:  `ruby template2font.rb myfirstfont.template.svg' 
* the script will
then write out a file called _myfirstfont.font.svg._ This is the multiColorfont
file. 
* the resulting SVG-font can actually be opened in FontForge and saved
as, for example, as TTF








