---
layout: post
title:  "2018 Campaign Finance, Part I: A Retrospective"
---

###### Incumbents ahead in funding almost always win Congressional elections (see 2018 counts [here](https://volsweep.github.io/assets/FECpt1/profile_breakdowns.png); excluding unopposed candidates, 97% of incumbents ahead in funding won in the House of Representatives (243/250) and 92% won in the Senate (24/26)).<!--more-->

Even when there is not an incumbent ahead in funding, there are other patterns between campaign finance filings and election outcomes which could help predict winners of future contests.

The Federal Election Commission (FEC) publishes U.S. federal election campaign finance data {% sidenote "1" "https://www.fec.gov/data/browse-data/?tab=bulk-data" %}. We noticed interesting patterns in the 2020 filings so far, so we analyzed the 2018 midterm filings to see how well they would have predicted the actual election outcomes {% sidenote "2" "https://ballotpedia.org/United_States_Congress_elections,_2018" %}. We are sharing our findings in a series of blog posts since they are of general interest.

This post is an overview of trends and exceptions in the 2018 data. The next posts will cover predictive model building and evaluation on 2018 data, and then 2020 predictions using those models. All relevant code is in &#8594;[this](https://github.com/volsweep/volsweep.github.io/tree/master/projects/FEC/2018)&#8592; GitHub repository. Let's look at the 2018 Senate plot and start hypothesizing.


## U.S. Senate

{% fullwidth "https://volsweep.github.io/assets/FECpt1/senate_2018.png" "Senate" %}

As you can see, most winners are incumbents ahead in funding (that is, you see a lot of solid circles to the right of any other symbol on the same horizontal line). Some notes before we hypothesize:

* _**Open seats:**_ The "+" symbol represents candidates for an open seat{% sidenote "3" " "Open" means there was no incumbent on the ballot, which happens due to certain redistricting scenarios, retirement/resignation/death of the sitting elected official, etc. You can see a plot of 2018 open contests with more than one candidate [here](https://blog.volsweep.com/assets/FECpt1/open_seats_2018.png)." %}. We're showing them for completeness, but will not address predicting their outcomes for now.

* _**Uncontested seats:**_ An opponent-less candidate will always win; no model needed. Disregard.

* _**Multiple incumbents:**_ PA_17 actually had two incumbents in 2018 due to two districts merging {% sidenote "4" "https://ballotpedia.org/Redistricting_in_Pennsylvania" %}. Scenarios like that are *very* exceptional, so we'll disregard for model building.

* _**Multiple candidates per party:**_ States like Louisiana{% sidenote "5" "https://ballotpedia.org/Primary_elections_in_Louisiana" %} and California{% sidenote "6" "https://ballotpedia.org/Primary_elections_in_California" %} have rules allowing more than one candidate per party on the ballot. We're going to assume for the most part that a maximum of one candidate per party ends up on the ballot.

* _**Timing assumption:**_ A big assumption we're making is that it's reasonable to make predictions using Q3 FEC filings. Incumbency status obviously doesn't change per candidate over the course of an election season, but funding almost certainly does (and possibly relative funding status). In this post we're not taking into account changes in funding over time.

* _**Time machine issue:**_ Finally, the FEC is reporting some candidates' final 2018 filing after the election date. We're assuming that post-election funding changes over part of November and all of December are relatively small compared to the rest of the election season.

Which brings us to...

**Hypothesis &#35;1: Any incumbent ahead in funding will win.**

This is the same as saying that any challenger behind in funding will lose. If this happens, our prediction is correct; otherwise, it's wrong. Since our first hypothesis imposes two conditions on a candidate that do not always align &#8212; incumbency status and relative funding status &#8212; we need a new predictive model whenever those conditions are not satisfied. &#8594;[Here](https://volsweep.github.io/assets/FECpt1/show_odds_senate_2018.png)&#8592; are the raw data for those scenarios, and the plot:

{% fullwidth "https://volsweep.github.io/assets/FECpt1/senate_2018_unexpecteds.png" "Senate unexpecteds" %}

So, what happened? We can use Hypothesis &#35;1 when an *incumbent* raises *more* funding, and we expect that candidate to win. Here, either:

**Hypothesis &#35;1 predicted incorrectly:**
* MO &#8212; Republican *challenger* raised *less* and won;
* ND &#8212; Republican *challenger* raised *less* and won.

or

**Hypothesis &#35;1 wasn't applicable:**
* TX &#8212; Republican incumbent raised *less* and won;
* NJ &#8212; Democratic incumbent raised *less* and won;
* FL &#8212; Republican *challenger* raised more and won;
* IN &#8212; Republican *challenger* raised more and won;
* NV &#8212; Democratic *challenger* raised more and won.


The FEC provides a breakdown of funding sources for the campaign finance data it reports. In the next posts we're going to check whether additional funding data can help explain these outcomes; for now, let's see how Hypothesis &#35;1 works on the 2018 House of Representatives data.


## U.S. House of Representatives
The full House of Representatives plot is a bit long to display, so head &#8594;[here](https://volsweep.github.io/assets/FECpt1/house_2018.png)&#8592; to check it out & be prepared to zoom in.

Like we did for the Senate, &#8594;[here]({{ site.url }}/assets/FECpt1/house_2018_unexpecteds.png)&#8592; is a plot of all House contests where Hypothesis &#35;1 is wrong or we can't use it. There seems to be some amount of total funding between $3-5MM when Republican incumbents become more likely to lose to Democratic challengers. To better visualize the relationship between candidates' funding in these scenarios, here is a scatterplot of Republican candidate total funds received versus Democratic candidate total funds received.  Note that the marker color shows the *winner's* party affiliation, not the *higher-funded candidate's* party affiliation:

{% maincolumn "https://volsweep.github.io/assets/FECpt1/scatter_RvD_House.png" "House unexpecteds scatter plot" %}

This brings us to something like:

**Hypothesis &#35;2: Any incumbent House Republican raising under ~$3MM will probably win; above ~$3MM, an incumbent House Republican behind in fundraising will probably lose{% sidenote "7" "Causality not implied." %}.**

And, finally, &#8594;[here](https://volsweep.github.io/assets/FECpt1/house_2018_most_unexpecteds.png)&#8592; are the contests remaining after we remove the ones where a Republican incumbent was behind in fundraising (resulting in either a win or a loss; raw data &#8594;[here]({{ site.url }}/assets/FECpt1/oddest_house_2018.png)&#8592;), and the scatterplot:

{% maincolumn "https://volsweep.github.io/assets/FECpt1/scatter_RvD_House2.png" "House most undexpecteds scatter plot" %}

So, what happened?

* PA_08 &#8212; Democratic incumbent raised *less* and won;
* OK_05 &#8212; Democratic *challenger* raised more and won (but under $3MM);
* IL_06 &#8212; Democratic *challenger* raised *less* and won;
* VA_10 &#8212; Democratic *challenger* raised *less* and won;
* FL_26 &#8212; Democratic *challenger* raised *less* and won;
* UT_04 &#8212; Democratic *challenger* raised *less* and won;
* CA_21 &#8212; Democratic *challenger* raised *less* and won;
* GA_06 &#8212; Democratic *challenger* raised *less* and won.


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Again, future posts will discuss whether additional FEC data on funding sources can help improve our Congressional election predictive capacity beyond Hypotheses &#35;1 (that any incumbent ahead in funding will win) and &#35;2 (that House Republican incumbents with less funding are more likely to win than House Republican incumbents with more funding, with a $3-5MM cutoff threshold).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Thanks for reading! We'd love to hear what you're thinking&#8212; please leave any thoughts & questions in the comments below. If you'd like a free plot of a particular state/U.S. territory, email us at contact@volsweep.com. &#8212;Rebecca


Notes on data cleaning:

* The FEC data do not include all candidates per election listed on Ballotpedia (exclusions possibly due to some candidates' not meeting the conditions requiring filing set by the Commission);
* we aggregated candidates who are neither Republican nor Democrat but appeared on the final ballot into a single "Third party" category;
* the FEC data appear to list Danny Tarkanian as a candidate for the Nevada U.S. Senate seat, which we changed to reflect his candidacy for Nevada's 3rd district U.S. House of Representatives seat;
* a contest name containing '00' &#8212; e.g., 'MT_00' &#8212; refers to an *at-large* U.S. House of Representatives seat;
* entries pertaining to the Marshall Islands U.S. House of Representatives election were adjusted to reflect that it is an at-large seat, not a "1st district" seat;
* we removed Liz Matory's entry pertaining to Maryland's 2nd district U.S. House of Representatives seat and kept her entry for Maryland's 8th district U.S. House of Representatives seat;
* Minnesota had one regular and one special U.S. Senate election in 2018 ('MN_senate' and 'MN_senate_special', respectively){% sidenote "8" "https://ballotpedia.org/United_States_Senate_special_election_in_Minnesota,_2018" %};
* David Trone won Maryland's 6th district U.S. House of Representatives seat but the candidates listed in the FEC data appear incorrect so we excluded that election;
* we excluded the 2017 Alabama U.S. Senate special election won by Doug Jones;
* we excluded the 2016 Illinois U.S. Senate election won by Tammy Duckworth;
* North Carolina's 9th district U.S. House of Representatives election results were declared invalid by the state's Board of Elections over concerns of ballot tampering{% sidenote "9" "https://ballotpedia.org/North_Carolina%27s_9th_Congressional_District_election,_2018" %};
* Susan Wild won Pennsylvania's 7th district U.S. House of Representatives election, not Pennsylvania's 15th district election;
* ten candidates' party listings conflicted between FEC and Ballotpedia (we corrected by inspection and found Ballotpedia was correct).
