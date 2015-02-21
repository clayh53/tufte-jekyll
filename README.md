# tufte-jekyll theme

The *Tufte-Jekyll* theme is a natural extension of the work done by [Dave Leipmann](https://github.com/daveliepmann/tufte-css) on Github that created a CSS file that allows web writers to use the simple and elegant style employed by Edward Tufte in his published materials.

To incorporate these styles into a Jekyll theme, I have made some very slight modifications that attempt to maintain the feel of the CSS styles in this repo.

## Installation

I'm not going to go into great detail here. I am just going to assume that anyone interested in either Jekyll, Edward Tufte's work or Github has some basic skills. I created this with Ruby 2.2.0 and Jekyll 2.5.3. There is absolutely nothing exotic going on here, so you can probably make any recent version of Jekyll work with this setup.

So copy, pull, download a zipfile or whatever and fire it up. 

```
%> cd ~/thatPlaceYouPutIt/tufte-jekyll
%> jekyll build
%> jekyll serve -w
```

And then point your browser at localhost:4000

## Some things about the things

I needed to create several custom Liquid tags to wrap content in the right kind of tags. You will create your posts in the normal way in the ```_posts``` directory, and then edit them with Github-Flavored Markdown. To all that GFM goodness, you can use the following custom Liquid tags in your content area.

### Sidenote

This tag inserts a *sidenote* in the content, which is like a footnote, only its in the spacious right-hand column. It is numbered. Just put it in the content like you would insert a footnote like so:

```
blah lorem blah{% sidenote 1 'This is a random sidenote'%} blah blah
```
And it will add the spans and superscripts. You are responsible for keeping track of the numbering!

### Margin note

This tag is essentially the same as a sidenote, but heh, no number. Like this:

```
lorem nobeer toasty critters{% marginnote 'Random thought when drinking'%} continue train of thought
```
### Full width image

This tag inserts an image that spans both the main content column and the side column. Full-width IOW:

```
blah blah {% fullwidth /url/to/image 'A caption for the image'}
```

### Main column image

This tag inserts an image that is confined to the main content column:

```
blah blah{% maincolumn /path/to/image 'This is the caption' %} blah
```

### Margin figure

This tag inserts and image in the side column area:

```
blah blah {% marginfigure /path/to/image 'This is the caption' %} blah
```
### New thought

This tag will render its contents in small caps. Useful at the beginning of new sections:

```
{% newthought 'This will be rendered in small caps %} blah blah
```
### Mathjax

Totally used this functionality from a [gist by Jessy Cowan-Sharpe](https://gist.github.com/jessykate/834610) to make working with Mathjax expressions a little easier. Short version, wrap inline math in a tag pair thusly: ```{% m %}mathjax expressino{% em %}``` and wrap bigger block level stuff with ```{% math %}mathjax expression{% endmath %}```

As a side note - if you do not need the math ability, navigate to the ```_data/options.yml``` file and change the mathjax to 'false' and it will not load the mathjax javascript.

## Other stuff

### SASS

I made a half-hearted effort to use Sass to create the css file used by this theme. If you would like to change things like fonts, colors and so forth, edit the ```_scss/_settings.scss``` file. I really didn't do any heavy lifting with SASS on this project since the CSS is relatively straightforward.

### Social icons

You can edit the ```_data/social.yml``` file and put in your own information for the footer links

### To-do list

It would be nice to have the sidenotes tag do all the counting for you. I have a feeling it is going to involve some ```@@rubyVariables``` to keep track of things. I'll probably get around to digging into this sooner or later, but if any of you Ruby gods out there want to take a whack at it, please fork this repo and go for it.

I also will probably be adding a very basic Rakefile to do things like create posts, and so forth. But not right now. 




