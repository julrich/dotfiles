#!/bin/bash -ex

# this is based on: https://gist.github.com/andsens/2913223

# Paste this into ssh
# curl -sL https://gist.github.com/andsens/2913223/raw/bootstrap_homeshick.sh | tar -xzO | /bin/bash -ex
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
$aptget install -y zsh tmux vim git

### Install homeshick ###
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
source $HOME/.homesick/repos/homeshick/homeshick.sh

### Set SSH_AUTH_SOCK etc. ###
eval `ssh-agent -s`

### Deploy dotfiles ###
homeshick --batch clone git@github.com:julrich/dotfiles

### Clone public repos ###
homeshick clone --batch robbyrussell/oh-my-zsh

### Link it all to $HOME ###
homeshick link --force

### Set default shell to your favorite shell ###
$chsh --shell /bin/zsh `whoami`
echo "Log in again to start your proper shell"
