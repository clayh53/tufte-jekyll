---
layout: post
title:  "Edge Cases for layout on Tufte-Jekyll"
date:   2015-02-18 21:46:04
categories: jekyll css
---
## Edge Case 1 from Quxiaofeng

### Remarks on ADMM version 1 - no blank lines between Markdown list items

Related algorithms

+ Split Bregman iteration {% sidenote 1 'Goldstein, T. and Osher, S. (2009). The split Bregman method for l1-regularized problems. SIAM J. Img. Sci., 2:323-343.' %}
+ Dykstra's alternating projection algorithm {% sidenote 2 'Dykstra, R. L. (1983). An algorithm for restricted least squares regression. J. Amer. Statist. Assoc., 78(384):837-842.' %}
+ Proximal point algorithm applied to the dual
+ Numerous applications in statistics and machine learning: lasso, gen. lasso, graphical lasso, (overlapping) group lasso, ...
+ Embraces distributed computing for big data {% sidenote 3 'Boyd, S., Parikh, N., Chu, E., Peleato, B., and Eckstein, J. (2011). Distributed optimization and statistical learning via the alternating direction method of multipliers. Found. Trends Mach. learn., 3(1):1-122.' %}

### Why this matters

Notice how the sidenotes display properly.

*Short answer*: Take out any blank lines between your list items.

Okay, this is a really strange thing about the Jekyll Markdown engine I have never noticed before. If you have a list, and you put a blank line between the items like this:

```
+ list item 1

+ list item 2
```

It will create an html tag structure like this:

```
<ul>
   <li>
      <p>list item 1</p>
  </li>
  <li>
      <p>list item 2</p>
   </li>
</ul>
```
Which *totally* goofs up the layout CSS.

However, if your Markdown is this:

```
+ list item 1
+ list item 2
```

It will create a tag structure like this:

```
<ul>
   <li>list item 1</li>
   <li>list item 2</li>
</ul>
```

Here is the same content as above, with a blank line separating the list items:


### Remarks on ADMM version 2 - one blank line between Markdown list items

Related algorithms

+ Split Bregman iteration {% sidenote 1 'Goldstein, T. and Osher, S. (2009). The split Bregman method for l1-regularized problems. SIAM J. Img. Sci., 2:323-343.' %}

+ Dykstra's alternating projection algorithm {% sidenote 2 'Dykstra, R. L. (1983). An algorithm for restricted least squares regression. J. Amer. Statist. Assoc., 78(384):837-842.' %}

+ Proximal point algorithm applied to the dual

+ Numerous applications in statistics and machine learning: lasso, gen. lasso, graphical lasso, (overlapping) group lasso, ...

+ Embraces distributed computing for big data {% sidenote 3 'Boyd, S., Parikh, N., Chu, E., Peleato, B., and Eckstein, J. (2011). Distributed optimization and statistical learning via the alternating direction method of multipliers. Found. Trends Mach. learn., 3(1):1-122.' %}
