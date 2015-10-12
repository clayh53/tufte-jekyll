---
published: true
layout: post
category: webdev
tags: "Web Development, VM, Vagrant, Databases"
date: 2014-07-16 11:24:00
excerpt: "A common problem people face when using a VM for development is how to connect to a database that is hosted on the VM but from an application running on their host machine. I scratched my head about this for a while but infact the solution is pretty simple. Here is is."
---

## Databases and Virtual Machines

A common problem people face when using a VM for development is how to connect to a database that is hosted on the VM but from an application running on their host machine. I scratched my head about this for a while but infact the solution is pretty simple. Here is is.

### Sequel Pro

First off, you need to get a nice database manage application. You could install phpMyAdmin on your VM and use that in the browser but I much prefer to have a seperate app that can handle many database connections. [Sequel Pro](http://sequelpro.com) is free and I find it really excellent and easy to use. I'll show you how to set it up to use with your VM.

First you need to create a new connection. When you open the app the new connection window will appear and you need to click on the SSH tab. We're going to create an SSH tunnel to your VM and access the database from there as if we were using localhost on that computer.

So the first lot of connection details are easy. These are the mysql details that you would use if you were connection to the database locally. They will be something like this:

![Screenshot of first part of SequelPro connection details](/assets/img/sequelpro1.png)

Now we've done that we need to go to the command line and get some SSH details. Get to your project root and type:

    $ vagrant ssh-config

This will give you a list of relevant information.

Simply copy the information for hostname, user and port into the correct fields. The key field can be filled by clicking on the key icon next to the field and navigating to `~/.vagrant-d/insecure_private_key`. You might need to click on the Show Hidden Files option and then navigate out and back into your home directory before .vagrant-d directory shows up.

And that's it. You complete connection window should look a bit like this:

![Screenshot of completed SequelPro connection window](/assets/img/sequelpro2.png)

Now you can add this connection to your list of favourites so yuo can use it again without having to remember all of the details. Once you've done that just click Connect and you're good to go!
