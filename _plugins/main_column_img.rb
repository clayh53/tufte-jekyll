## Liquid tag 'maincolumn-figure' used to add image data that fits within the
## main column area of the layout
## Usage {% maincolumn 'path/to/image' 'This is the caption' %}
#
module Jekyll
  class RenderMainColumnTag < Liquid::Tag

  	require "shellwords"

    def initialize(tag_name, text, tokens)
      super
      @text = text.shellsplit
    end

    def render(context)
      baseurl = context.registers[:site].config['baseurl']
      if @text[0].start_with?('http://', 'https://','//')
        "<figure><img src='#{@text[0]}'/><figcaption class='maincolumn-figure'><span>#{@text[1]}</span></figcaption></figure>"
      else
        "<figure><img src='#{baseurl}/#{@text[0]}'/><figcaption class='maincolumn-figure'><span>#{@text[1]}</span></figcaption></figure>"
      end
    end
  end
end

Liquid::Template.register_tag('maincolumn', Jekyll::RenderMainColumnTag)
