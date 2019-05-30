#!/bin/bash -ex

# this is based on: https://gist.github.com/andsens/2913223

# Paste this into ssh
# curl -sL https://raw.githubusercontent.com/julrich/dotfiles/master/util/bootstrap.sh | /bin/bash -ex
# When forking, you can get the URL from the raw (<>) button.

### Set some command variables depending on whether we are root or not ###
# This assumes you use a debian derivate, replace with yum, pacman etc.
aptget='sudo apt-get'
chsh='sudo chsh'
if [ `whoami` = 'root' ]; then
	aptget='apt-get'
	chsh='chsh'
fi

### Install git and some other tools we'd like to use ###
$aptget update
$aptget install -y git mr docker.io

### Set default shell to your favorite shell ###
$chsh --shell /bin/bash `whoami`

### Install homeshick ###
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
source $HOME/.homesick/repos/homeshick/homeshick.sh

### Set SSH_AUTH_SOCK etc. ###
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa_second

### Deploy dotfiles ###
homeshick --batch clone git@github.com:julrich/dotfiles

### Clone public repos ###
mr checkout

### Link it all to $HOME ###
homeshick link --force

echo "Log in again to start your proper shell"
