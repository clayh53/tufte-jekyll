## Liquid tag 'maincolumn' used to add image data that fits within the main column
## area of the layout
## Usage {% marginfigure /path/to/image 'This is the caption' %}
#
module Jekyll
  class RenderMarginFigureTag < Liquid::Tag

  	require "shellwords"

    def initialize(tag_name, text, tokens)
      super
      @text = text.shellsplit
    end

    def render(context)
            baseurl = context.registers[:site].config['baseurl']
            "<label for='#{@text[0]}' class='margin-toggle'>&#8853;</label>"+
            "<input type='checkbox' id='#{@text[0]}' class='margin-toggle'/>"+
            "<span class='marginnote'><img class='fullwidth' src='#{baseurl}/#{@text[1]}'/><br>#{@text[2]}</span>"

    end
  end
end

Liquid::Template.register_tag('marginfigure', Jekyll::RenderMarginFigureTag)
