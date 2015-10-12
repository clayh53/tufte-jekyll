---
layout: post
title: About
published: true
---

<ul>
    {% for category in site.categories %}
    <li class=""><h3 class=""><a href="{{ site.url }}/writing/{{ category | first }}">{{ category | first | replace: 'webdev', 'Web Development ' | replace: 'books', 'Book Reviews' }}</h3></a></li>
    {% endfor %}
</ul>