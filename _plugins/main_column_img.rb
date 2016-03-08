# Jekyll tag plugin to render image full-width of main column
# Usage:
#   {% maincolumn "path/to/image.jpg" "This is the caption" %}
#   {% maincolumn "http://example.com/image.jpg" "This is the caption" %}

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
        "<figure><figcaption>#{@text[1]}</figcaption><img src='#{@text[0]}'/></figure>"
      else
        "<figure><figcaption>#{@text[1]}</figcaption><img src='#{baseurl}/#{@text[0]}'/></figure>"
      end
    end
  end
end

Liquid::Template.register_tag('maincolumn', Jekyll::RenderMainColumnTag)
