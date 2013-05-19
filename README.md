multiColorfont
==============

a jQuery plugin for dynamic rendering of multi-colored fonts on webpages

See:  http://ideogram.nl/multiColorfont/  for a demo.

What does it do?
----------------

MultiColorFont displays fonts on a webpage rendered in multiple colors.

	It turns dynamically (i.e.: on page-load) the content of HTML-element into colored characters. So, your originally boring looking H2 in Arial will be turned into a header made from multi-colored characters.
	How does it do that?

	By using a jQuery-plugin and a specially prepared SVG-font in a CUFON-like manner.

Colorfont is a jQuery-plugin that uses the Raphael-library for writing to vectors to the canvas. It makes use of a SVG-font that has been especially prepared to contain multiple layers of colors.
The colorfont-plugin adds this font as an object to the DOM (in the same way Flash-objects ar added.) It is then read out and written to a canvas on the same position as the the original element.

How do I use them on my page?
-----------------------------

Download the attached zip-file. It contains:

* an example HTML document (index.html) that's pretty self-explanatory if you have some HTML/jQuery knowledge.
* the multiColorfont-jQuery plugin (in the js folder)
* the jQuery and the Raphael.js libray
* some example SVG-fonts
* some ruby scripts to assist in the font making. (More on that later...)
* Choose your font and the colors in the arguments of the multiColor-function call. Or: just look at the multiColorfont.html page and with some basic knowledge of HTML, you'll be able to figure it out.

	The multiColorfont.html-file should be the only place you'll need to adjust. All the settings can be accessed from the jQuery-statements at the bottom.
	Be aware that:
	* The colorfont should on the same server as the page requesting it.
	* The size the colorfont is rendered in, is determined by the CSS-font size of the original tag.

How do I create my own SVG-multicolored-font?
---------------------------------------------

Good question! I'll come back on this shortly :)