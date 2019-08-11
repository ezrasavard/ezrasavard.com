---
title: What I'm Reading - Tech Stuff
date: 2019-08-10
tags: [misc, links, software]
---

My [last links write-up]({{site.baseurl}}/) was getting too long, so I broke out a few of the
more software specific pieces here.


[The Wealthy Western Web](https://www.smashingmagazine.com/2017/03/world-wide-web-not-wealthy-western-web-part-1/)
<br>
One of the motivations for keeping this site static, and also reworking it with semantic HTML and
simpler CSS was to support accessibility, both for those who use assistance technologies, but
also for people on bad internet connections and low power devices. My work has given me a lot of experience
thinking about assistive technologies, but not so much low-end devices.
This [piece from 2017](https://www.smashingmagazine.com/2017/03/world-wide-web-not-wealthy-western-web-part-1/) was
a part of the inspiration for thinking more about those users in particular.

<!--more-->

[Related: When to use Web Workers](https://dassur.ma/things/when-workers/)
<br>
The author argues that web workers are an important tool in making devices work better in poor network conditions
or when they don't have the CPU to do everything on-demand.

[Smart Home Devices in Discovery Phase](https://www.ben-evans.com/benedictevans/2019/4/3/tu4vs2tioi24biufgot7agru2lgbkh)
<br>
Ben Evans compares the current state of IoT and "AI" powered devices to early electrical or even mechanical appliances.
He talks about this discovery phase where consumer selection is being used to figure out what kinds of devices
people are actually going to find worth owning.

This also reminds me of the awkward device size exploration
that was taking place early in the smartphone age, where there was not yet a common understanding of which sizes
and formats would be most useful. Survivors include the "all screen" smartphone and the tablet. We could physical
phone keyboards mostly amongst the dead, along with most phablets and transformers.
I'm still not convinced on Apple's "toaster-fridges" argument against transformers, because they run on the same engines...
if anything, I feel more like "freezer-fridges" is appropriate, and those *are* popular.

With smart home devices, I've been coming around to my Echo unit for finding out the weather, setting alarms, and
controlling music somewhat, but I haven't felt a compelling want for more intelligence from my other appliances.
Perhaps an extremely smooth system for phone or video chatting while allowing me to cook and wash dishes;
something better than noise cancelling headphones.

Oh, and I did briefly own a lightbulb that needed to be rebooted sometimes.

[The Price of Celebrity](https://www.cameo.com/snoopdogg)
<br>
Celebrities of various status levels deliver custom greetings for a price.
The use of 30 second, low effort videos means that the entirety of the value is on celebrity, with everything else stripped out.

The pricing on this service is going to be particularly interesting to watch and see which celebrities join up. Snoop Dogg is on there at $500, while Charlie Sheen is there at $350, and some not-well-known TV actors are priced alongside Instragrammers and YouTubers in the $15-$25 range. This would have been an unthinkably expensive service twenty years ago. The company, Cameo, is fairly new and based out of Chicago.

[Software Engineering Lessons Learned](https://blog.juliobiason.net/thoughts/things-i-learnt-the-hard-way/)
<br>
Good list of common sense practices for working as a software engineer.
I think these are mostly well know, but this article is well written and linkable, which is handy!

[Software Engineering Management Lessons Learned](https://www.defmacro.org/2014/10/03/engman.html)
<br>
Similarly excellent write-up about the experiences of working as a software engineering manager.
Using this list, my own experience, and some Joel's list like pages, I have put together a questionnaire
for interviewing a company. I'll publish it soon, so here is a TODO:

*TODO: publish my company-interviewing list and put a link here!*.

[Cognitive Load and Service Sizes](https://techbeacon.com/app-dev-testing/forget-monoliths-vs-microservices-cognitive-load-what-matters)
<br>
Using the concept of cognitive load to estimate the ideal size of a service for a given team and complexity of code.
I find cognitive load (and computational kindness) to be very useful ideas for both sizing technical
things, and especially for communicating about them.
I think there is also a time dimension to this, where a team that has owned a service longer suffers
a lower cognitive load from its size. Switching people from project to project frequently would
necessitate very small or modular codebases.


[Cost of Javascript in 2019](https://v8.dev/blog/cost-of-javascript-2019)
<br>
A look into the relentless march of optimization that occurs with the v8 engine.
Full of interesting details about the capabilities of a modern browser.

[Equity Compensation as a Driver of Income Inequality?](https://economics.stanford.edu/sites/g/files/sbiybj9386/f/abstract_5.pdf)
<br>
When I first read this, I thought it was an interesting take on rising income inequality, but now
I don't think it boils down to anything other than "really well paid professionals get richer via investing."
Here is my reasoning:

The practice of equity compensation in tech has created an opportunity for a worker to gain access
to very high risk investments from their employer. But since we (typically) only have one employer,
we aren't exactly doing hits based investing with equity compensation.

So if equity compensation is only widely available to a particular class of workers (e.g. tech workers),
then that means tech workers are capable of being exposed to much higher risk investments than most people.
That would result in tech workers, on average, making a lot of money over the long term.

But does equity compensation actually matter in this narrative? I don't think it does.

Our compensation essentially includes liquid and illiquid components,
where the illiquid components are tied to a high risk investment that we chose by joining the company
(or not that high risk if you work at e.g. Microsoft). In the case of public companies,
this isn't really any better than being given the money and investing it in something high risk ourselves.

*Aside, in the case of private companies, equity compensation provides both the value of the investment,
but also the **access to it** that would otherwise be difficult to obtain. Still, because
there are plenty of high risk investments that are accessible to most people, I'm going to focus
on the public case.*

I think the real gotcha here is that equity compensation in tech is on top of an already excellent salary.
If a plumber were making the same salary
*plus the value of the equity comp* as cash, then yes, they should probably invest "the equity portion" in high risk
investments too.
