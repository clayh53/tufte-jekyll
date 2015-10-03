mmodule Jekyll
  class MathJaxBlockTag < Liquid::Tag
    def render(context)
      '&#8203;<script type="math/tex; mode=display">'
    end
  end
class MathJaxInlineTag < Liquid::Tag
    def render(context)
      '&#8203;<script type="math/tex">'
    end
  end
class MathJaxEndBlockTag < Liquid::Tag
    def render(context)
      '</script>'
    end
  end
class MathJaxEndInlineTag < Liquid::Tag
    def render(context)
      '</script>'
    end
  end  
end
 
Liquid::Template.register_tag('math', Jekyll::MathJaxBlockTag)
Liquid::Template.register_tag('m', Jekyll::MathJaxInlineTag)
Liquid::Template.register_tag('endmath', Jekyll::MathJaxEndBlockTag)
Liquid::Template.register_tag('em', Jekyll::MathJaxEndInlineTag)