---
layout: blog_post
title: Workshop material, Continuous Delivery style
---
These past couple of weeks, I've been preparing a workshop comprising a slide deck and some practice material.
I have done this before but, this time, I also had to select and prepare the development environment for the trainees.
Being the CD (Continuous Delivery) fanatic that I am, I started looking around for options for:

1. Getting the environment spec into SCM, preferably in the same repo as the slide deck
2. Building a pipeline for building the environment
3. Actually getting the environment into the hands of the trainees

This post is essentially the story of how I got the whole beast to work.

# Slide Deck

From past experience, I had already got this part worked out.
I'm sharing this because someone might find it interesting.

I write my slide decks in the (most excellent) LaTeX beamer class: it has everything I need to build clean, simple slides really fast.
This might seem convoluted ("they're simple slides, man") but, honestly, I've been using LaTeX for so long and with such great results that I can't use anything else (Prezi, PowerPoint & Co make me dizzy).
The document is split into modules, all built from a bunch of Makefiles (hipster build alert!).

For diagrams I use PlantUML, which outputs eps images that I include in my document (PlantUML is great too, you should check it out).

For code snippets I use Python's pygments package, which produces LaTeX output.
It sometimes needs a little tweaking for font sizes but the colors and resolution are stunning and really help with readability.
Some of my slides are actually just code that I then explain in the sessions, so this is an essential part of the slide deck.

# Development Environment

I've been using Vagrant for a long time now, so this seemed like a nice fit.
Then I remembered that the environment needed:

* A VM with a desktop environment
* An IDE installation (I chose Intellij Community)
* A Java JDK installation
* My practice material

Dowloading and installing all of this stuff is feasible but seemed hacky...so I decided to build a Vagrant base box with everything except my material in it.
On previous travels (namely trying to boot Windows VMs on Virtualbox), I had already found Packer (from the same guy(s) that brought you Vagrant), which essentially is a tool to build VMs (with the option to generate a Vagrant base box), and I decided to go with that.

Then, another bump on the road: building VMs needs resources (at least more than I have on my cheap laptop).
It took a really long time to build the whole thing on it, and still left me with a problem: how do I publish this?

Enter Atlas (Vagrant guys again, they're everywhere!), which lets you run Packer in the cloud and hosts your VMs.
This is incredibly helpful for the sort of problem that I was trying to solve, and the only minor issue I have with it is that I don't know how to auto-increment version numbers and occasionally get failures because I forget to update them.

# Getting a pipeline

At this point, my workflow was:

1. Build and package the presentation, practice material and Vagrantfile using my VM
2. Put them in my Google Drive and make them public
3. Build the VM in Atlas
4. vagrant up

This would be OK for most people but, for me, manually uploading stuff to Drive was just...gross.
Also, I was still building and packaging on my machine, which is also less than ideal.
Ok, time to find a CI engine: I went with Semaphore.
This was mostly because it was the first I could find that mentioned the ability to install tools for the build, and CI engines with built-in LaTeX support just don't exist.
It's not really amazing (it keeps switching my command scheduling on every change, even for single letter changes) but it gets the job done.

After getting the slide deck to build under Semaphore, I realized I had run myself into a dead end because, after some searching, I couldn't find any way to automatically upload to Google Drive, in particular, from my Semaphore pipeline.

I have to say that I'm a bit surprised at how hard it was to find a cloud storage service that:

* Is free
* Allows uploading things from scripts trivially
* Works

In the end, I compromised with the free part and decided to go down the rabbit hole of Amazon Web Services.
It fit the bill comletely in terms of scripting (I'm using the Python AWS CLI).
Despite not normally being a free service, they have Free Tier for a year, which should be more than enough for what I'm looking for.
By the time the offer expires, I'm hoping to have tried the service enough that I'm ready to either drop it or actually commit to paying for it.

# Conclusion

This pretty much sums up my current setup, essentially a mash-up of free cloud services.
The pipeline that I have just for some workshop material is incredibly productive, especially considering what I'm paying (which is nothing).
The experience is confirming my suspicions that cloud has reached the point where not using it is hard to justify.

As a final thought, if you know some tools that you think might be nice for me to try, let me know!
I'm always interested in improving my toolchain.
