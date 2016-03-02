# freeipa_upstream_builder
A docker image to build freeipa packages from upstream repo with developmental patches, optionally applied on top of it

In order to build the image you need to perform the following steps:
1. Git clone this repo and chdir into the freeipa\_upstream\_builder folder
2. create a .ssh folder in it with the authorized\_keys, containing the pub key
   you will use to ssh into running container.
4. Update your $HOME/.ssh/config so that to use the proper private key to ssh
   to localhost (needed to access your builder container)
3. Actually build the image: <pre><code>VERSION=\`awk '/FROM/ {print $2}' Dockerfile | sed "s/fedora://"\` ; docker build -t f${VERSION}builder .</code></pre>

To use the image then do the following:
1. Create the folder named FreeIPA under you home directory: and an rpm folder inside FreeIPA: mkdir -p $HOME/FreeIPA/rpms
2. create a container with the FreeIPA folder exported to the container as a volume:
<pre><code>docker run -P -v /path/to/folder:/data:Z ipabuilder</pre></code>
That's it! Now you can ssh to the container and launch /root/freeipa/build.sh
to build the upstream code. Once the build is finished, it will create a 
subfolder in the FreeIPA/rpms, named as fedora version of the docker image
and put the packages in this subfolder
To ssh into the container do 
<pre><code>ssh localhost -p \`docker ps | grep $CONT\_NAME | sed -re 's/.*([0-9]{5}).*/\1/'\`</pre></code>
where $CONT\_NAME is the name of your container, for example desperate\_einstein

If you want to apply some patches to the upstream repo before building, create
a folder named patches in the FreeIPA folder and put your patches there, then call the build script
in the container.

Basically, once you have built your image and created all necessary folders, you can
call buildrpms.sh script and it will do all the magic for you: launch container, build
the packages and destroy the containers once ready. It's a good idea to always keep
your image up-to-date, so just put actualize\_builder.sh in your cron.daily
