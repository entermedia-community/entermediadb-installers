Installation
# Before you run the installation script, you must make sure apt sources list has access to libfaac. Perform the following tasks:

# Edit your repository sources list (vi shown here, use your preferred editor):

sudo vi /etc/apt/sources.list

# At the end of the file, add the following line:

deb http://www.deb-multimedia.org/ wheezy main non-free

# Save and exit the text editor and attempt to update apt (this may fail):

sudo apt-get update

# If there is an error, at the end of the output there should be a public key. Replace ${YOUR_KEY} below with this key. Enter the following commands to authenticate with your public key:

sudo gpg --keyserver pgpkeys.mit.edu --recv-key ${YOUR_KEY}
sudo gpg --armor --export ${YOUR_KEY} | sudo apt-key add -
sudo apt-get update

# Now you are ready to run the installer script (install.sh), you may have to answer Yes to some prompts from iptables-persistent (press ENTER twice)

# When the script finishes, you may wish to configure authentication for the entermedia user, because only that user should interact with your webapp.
# The easiest way to do this is:

sudo passwd entermedia

# ... and enter the credentials you prefer

# You should now be able to visit the hostname for your machine (port 80) and see your EnterMedia application running
