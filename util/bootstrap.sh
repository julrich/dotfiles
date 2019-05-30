#!/bin/bash -ex

# this is based on: https://gist.github.com/andsens/2913223

# Paste this into ssh
# curl -sL https://raw.githubusercontent.com/julrich/dotfiles/master/util/bootstrap.sh | /bin/bash -ex
# When forking, you can get the URL from the raw (<>) button.

### Set some command variables depending on whether we are root or not ###
# This assumes you use a debian derivate, replace with yum, pacman etc.
aptget='sudo apt-get'
aptkey='sudo apt-key'
addaptrepository='sudo add-apt-repository' 
docker='sudo docker'
usermod='sudo usermod'
chsh='sudo chsh'
if [ `whoami` = 'root' ]; then
	aptget='apt-get'
	aptkey='apt-key'
	addaptrepository='add-apt-repository' 
	docker='docker'
	chsh='chsh'
fi

### Update repositories ###
$aptget update

### Install Docker CE (see: https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository) ###
#### Uninstall old versions ####
$aptget remove -y docker docker-engine docker.io containerd runc
#### Install packages to allow apt to use a repository over HTTPS ####
$aptget install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
#### Add Docker’s official GPG key ####
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $aptkey add -
#### Verify that you now have the key with the fingerprint ####
$aptkey fingerprint 0EBFCD88

$addaptrepository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
#### Install Docker CE #####
$aptget update
$aptget install -y docker-ce docker-ce-cli containerd.io
#### Test correct docker installation ####
$docker run hello-world
#### Add user to docker group ####
$usermod -a -G docker `whoami`

### Install git and some other tools we'd like to use ###
$aptget install -y git mr

### Set default shell to your favorite shell ###
$chsh --shell /bin/bash `whoami`

### Install homeshick ###
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
source $HOME/.homesick/repos/homeshick/homeshick.sh

### Set SSH_AUTH_SOCK etc. ###
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa_second

### Deploy dotfiles ###
homeshick clone git@github.com:julrich/dotfiles

### Clone public repos ###
mr checkout

### Link it all to $HOME ###
#homeshick link --force

echo "Log in again to start your proper shell"
