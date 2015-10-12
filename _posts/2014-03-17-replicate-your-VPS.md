---
published: true
date: 2014-04-18
layout: post
category: webdev
tags: "Web Development, VM, Vagrant, Salt"
excerpt: "In the last post we looked at how to setup and provision your VM using Vagrant and Salt. In this post I'm going to dive a little deeper (only a little) and walk through how I have setup my VM to duplicate the VPS (Virtual Private Server) that I will be using."
---

## Replicate Your VPS - custom provisioning, bash scripts, permissions and more!

In the last post we looked at how to setup and provision your VM using Vagrant and Salt. In this post I'm going to dive a little deeper (only a little) and walk through how I have setup my VM to duplicate the VPS (Virtual Private Server) that I will be using.

Why do I need to do this?

Well, the whole point of using a VM for development is to make your development environment as close as possible to your production environment so that you don't get any nasty surprises when it comes time to deploy.

In my case I have signed up for a VPS with a company called [ServerGrove](http://servergrove.com/vps). I chose them because they had good reveiws especially from the Symfony2 community which is currently my PHP framework of choice, and certainly what I would be using on my next project. I have found their service brilliant so far. I think the pricing is competitive, their UI is really easy to use but best of all I have found their customer service and support to be second to one. I have honestly never experienced anything like the level of support that I've had from these guys. Total superstars.

So, in order to replicate my ServerGrove VPS as closely as possible I need to try and copy the following things:
1. Use the same OS / Base Box
2. Provision it with the same LAMP stack

The OS part is pretty straight forward. I'm using "precise64" which is a pretty good match, at least for the time being.

The interesting part is when we get to provisioning our LAMP stack.

I will try and explain everything but if you're feeling impatient I have also put up this configuration on [GitHub](https://github.com/musonic/vagrant-salt-servergrove) where you can either just look at the code or download it.

### Let's Give It A Bash

ServerGrove usefully provide publically available repositories of all the software that they install on their VPSs. The question is, how do we use them?

If you read the Vagrant [docs](http://docs.vagrantup.com/v2/getting-started/provisioning.html) you will see that in their getting started tutorial they provision their first box by using a script that they call directly from their VagrantFile. This script is called a bash script and it effectively allows you to run the same commands that you would run in the command line. As such, it is really the simplest way of provisioning your VM, but it's not the most flexible. 

However, we need to run some commands on our VM _before_ we start to provision it in order for us to download the software from the ServerGrove repo and use that to provision rather than the defaults.

Start by creating a new file in your project root (the same level as your VagrantFile) and call it anything you like - I've called mine "bootstrap.sh".

Copy and paste the following into the file, but remember to read the explanation that follows carefully so that you understand what you've just done!

    #!/usr/bin/env bash
    
    apt-get -y install curl
    
    echo deb http://repos.servergrove.com/servergrove-ubuntu-precise precise main > /etc/apt/sources.list.d/servergrove.list
    
    curl -O http://repos.servergrove.com/servergrove-ubuntu-precise/servergrove-ubuntu-precise.gpg.key 
    apt-key add servergrove-ubuntu-precise.gpg.key
    
    apt-get update
    
    rm -rf /var/www
	ln -fs /vagrant /var/www

The first line is important. The first two characters mark the beginning of the script. The rest of the first line is defining which shell will be used to run the commands. In our case it is Bash (Bourne Again SHell). If you would like to find out more about Unix Shells and Bash in particular take a look at [this beginners guide](http://www.tldp.org/LDP/Bash-Beginners-Guide/html/).
Next we make sure that [curl](http://curl.haxx.se/docs/faq.html) is installed.
The third command gets the contents of the remote repository and places it in a new file on our VM. This is where the ServerGrove versions of PHP, Apache etc. reside.
Next up we have to add a [gpg key](http://www.gnupg.org) for security.
Finally, we update apt-get so that it can now access the packages contained in the ServerGrove repository.

I'm hoping that I will be able to move all of this stuff into my SaltStack configuration but I haven't worked out yet how to do that. The main thing is that this works!

Next is provisioning...

###Salt and Symfony

At this point it's worth recapping exactly what I am trying to achieve. As well as trying to replicate my ServerGrove VPS as closely as possible I am also needing to prepare my VM for using the [Symfony2 PHP framework](http://symfony.com). Symfony2 has certain [requirements](http://symfony.com/doc/current/reference/requirements.html) which take a little bit of extra configuring on most systems but the SaltStack options I'm about to explore will be useful and resuable regardless of what you are trying to do with your LAMP stack.

###PHP extensions and config

Let's make a start by setting up PHP.

Since we are now using the ServerGrove repos we need to change our top.sls file to install their version of PHP rather than what we had before. Delete the file called libapache2-mod-php5.sls and create a new file simply called php55.sls. This will be very similar to the old file we had, but we are also going to use it to install some PHP extensions. Here is the complete file:

	php55:
    	pkg:
        	- installed
        	- pkgs:
            	- php55
            	- php55-apcu
            	- php55-mod-php
            	- libjpeg-turbo8 
            	- php55-intl
 
This should look very familiar to you now. The pkgs key lists the exact packages we want to be installed. Notice how we've include apc caching and the intl extension that is required by Symfony2. 

Now you can update your top.sls by simply replacing the old libapache2-mod-php5.sls file name with our new php55.sls.

Simple!

Well, not quite... for PHP to work properly we need to create a php.ini file that contains some custom directives. Some are required by Symfony2 and others are used to enable the extensions we've just installed. We'll come back to this in a bit. For now, let's get a bit more complex...

###Apache

In our previous setup we very simply used Salt to provision our VM with Apache but simply requesting the default apache2 module. This time though we're going to take things further and get more complex.

Remember that our goal is to replicate the ServerGrove VPS setup on our local VM. To do this accurately we need to do more than simply use the same packages. ServerGrove will have configured their servers in certain ways that they think best serve their customers. We need to also replicate these configurations. Navigate into your VPS either using the dashboard file manager or ssh from the command line. Then navigate to /etc. In this directory there will be a directory called apache2. Download the entire apache2 directory and place it in your salt/roots/salt directory on your local machine. This directory contains all the custom configuration from your VPS that you can replicate locally.

Next we need to rewrite our apache state. Create a new file in salt/roots/salt and call it apache2-mpm-prefork.sls. The first part of this file will be very familiar:

	apache2-mpm-prefork:
  		pkg:
    		- installed
  		service:
    		- running

We request the module "apache2-mpm-prefork" and install it and then we simply check that it is running. 

Now we need to add some configuration. First we're going to add the main apache2.conf file. Here is the code to add below the previous codeblock.

	/etc/apache2/apache2.conf:
    	file.copy:
        	- name: /etc/apache2/apache2.conf
        	- source: /srv/salt/apache2/apache2.conf
        	- force: True
        	- makedirs: True
            
In Salt terms this is another state. It is the state the refers to the file "/etc/apache2/apache2.conf" whereas the previous state referred to the package "apache2-mpm-prefork". Here's what is going on here:
1. We are going to use the copy function of the Salt file module
2. We tell it the name and location of the copied file i.e. the destination
3. We tell it the location of the file we want to copy i.e. the source file
4. We tell it to overwrite any files that already exist at the destination location with the same name.
5. We tell it to create any required subdirectories if they don't already exist.

When you break it down like this it is quite straightforward. However, there is still one big problem. How did we get our apache2.conf file into /srv/salt/apache2 on the VM in the first place?

For this we need to return to Vagrant for a minute and open up our Vagrantfile.
Look for the lines where we set the configuration for synced folders. Delete what is there and replace it with the following:

	  ## For masterless, mount your file roots file root
  	config.vm.synced_folder "salt/roots/", "/srv/", 
    	:owner => "vagrant",
    	:group => "www-data",
    	:mount_options => ["dmode=775","fmode=664"]
  	config.vm.synced_folder ".", "/vagrant", 
    	:owner => "vagrant",
    	:group => "www-data",
    	:mount_options => ["dmode=775","fmode=664"]
 
This tells vagrant that we want to sync two folders. The first is our "salt/roots" directory which will be synced with the "/src/" directory on the VM and the second is the sync our root directory with "/vagrant" on the VM. We then set some options for each. These set the directory permissions on the VM and are basic settings that allow us to read and write depending on the user and group. Remember that vagrant creates a user "vagrant" rather than using root - this is why we need to make this user the owner of these synced directories.

It should now make sense why we need Salt to copy our Apache config files. The files are stored locally and when Vagrant runs it syncs those files into "/srv/". From there we get Salt to copy them into the right place for Apache to find them.

Whilst you're getting used to file.copy why not do the same thing for the "/srv/salt/apache2/conf.d/php.conf" file? You should be able to do this using the code we used above, but if not then head over to the [github repo](https://github.com/musonic/vagrant-salt-servergrove/blob/master/salt/roots/salt/apache2-mpm-prefork.sls) and have a look how I did it.

Having looked at file.copy we're now going to use another of salt's file module functions - file.managed. This function is incredibly useful because it is so versatile. We are going to use it firstly to create and manage a file to store our virtual host configuration. To do this we simply create another state in our apache2-mpm-prefork.sls file:

	/etc/apache2/sites-enabled/mysite.com.conf:
    	file.managed:
        	- user: root
        	- contents_pillar: virtualhosts:vhost
        
Again, this should all look very familiar. We tell salt the name and location of the file that we want it to manage. We then tell it to use the root user. The final line is the interesting one as it introduces a new concept. 

###Pillars of Salt
Salt uses a concept they call Pillars. Pillars are simply files that contain pretty much any sort of data that might be required by the states themselves. It is simply a nice way of keeping things organised. In the above example we have a file in our pillar directory called "virtualhosts.sls" and in that file is a YAML declaration with "vhost" as the key. Here's the contents of the file:

	virtualhosts:
    	vhost: |
        	<VirtualHost *:80>
            	    CustomLog /var/log/apache2/mysite.com-access.log combined
                	DocumentRoot /var/www/web
                	ServerName mysite.com
                	ServerAlias localhost

                	<Directory /var/www/web>
                        AllowOverride All
                        Order allow,deny
                        Allow from all
                	</Directory>
        	</VirtualHost>
            
So you can see that we use a pipe (|) before we simply write out a standard apache virtualhost configuration. I won't go into this all now, but a small amount of googling will help you find information about virtualhosts. Obviously, replace "mysite" with whatever your site is called!

In just the same way that salt state files are collected together in a top.sls file, so are pillars. Create a top.sls file in your pillar directory and copy the following in:

	base:
  		'*':
    	  - data
    	  - virtualhosts
          
You see? Exactly like we did with the states top file. You will see we have also requested another file, "data", which we will come to in a minute.

To return to our file.managed state it should now be clear that all the "contents_pillar" option does is to take the contents of our pillar file (virtualhosts.sls) and make that the contents of the file it is managing.

We're nearly there with our apache configuration now. The only thing left is to create our php.ini file. We do this exactly like above:

	/usr/local/php55/lib/php.ini:
    	file.managed:
        	- contents_pillar: data:custom
            
and the contents of "pillar/data.sls" is:

	data:
    	custom: |
      	  extension=intl.so
      	  short_open_tag = Off
      	  opcache.enable = "0"

you can now add any custom php configurations you like to this file.

There is one final thing we must do before we can leave apache and move on. When ever we make any changes to the php.ini file we need to restart apache for the changes to take effect. In order for this to happen we need to tell salt to watch our php.ini file. If it detects any changes it will restart the service. Just underneath where you have added the "running" option, add the following:

	    - watch:
      		- file: /usr/local/php55/lib/php.ini

Remember to check the [GitHub repo](https://github.com/musonic/vagrant-salt-servergrove/blob/master/salt/roots/salt/apache2-mpm-prefork.sls) if you want to make sure you've got it right.

###What about MySQL?

Easy. You'll be pleased to know that nothing has changed in how we've setup our MySQL state, so you can just leave that exactly how it is!

###Nearly there!
We have now been through and made sure that all our states are how we want them. We just have one more job to do. Open up your minion file and add the line:

	master: localhost

This tells Salt that we are running in masterless mode. In other words, rather than having one master controlling many different minions, we just have one minion that is effectively it's own master. If you open up the [minion file](https://github.com/musonic/vagrant-salt-servergrove/blob/master/salt/minion) in the GitHub repo you will see a whole load of configuration options that are currently commented out but you could decide to use if you so chose.

###Start her up
So now you should be set to start up your Virtual Machine. Run

	$ vagrant destroy

to start completely afresh and then

	$ vagrant up

and see your entire setup build before your eyes. 

###Any problems?
Whilst getting this working I did run into a few problems and found that there were a few things that were helpful when trying to figure out what had gone wrong.

The first place to look is the logs. They are located on your VM (so you need to ssh into it) at /var/logs and you should see there an apache error log and an apache access log. Open these up in nano and see what is there. They will give a big clue as to what went wrong.

If you discover that there is something going wrong with your salt configuration a useful thing to do, rather than re-provisioning using vagrant every time, is to run salt directly on the vm from the command line. Firstly ssh into your vm.

	$ vagrant ssh

Then you can run a command called salt-call. This will allow you to debug the salt.highstate function which is what runs all your salt states.

	$ salt-call -l debug state.highstate

This will give you very detailed and verbose information about every stage of the process.

For more info about salt and for finding help don't forget to check out their [docs](http://docs.saltstack.com).

###Well done for getting this far!

If you're still reading then well done! I hope you've found it interesting and useful. My next post will probably be on Symfony2 but check back and find out and be sure to post links to this blog and leave comments if you've found it useful. Thanks for reading!
