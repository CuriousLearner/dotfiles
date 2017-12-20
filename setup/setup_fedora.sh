#!/usr/bin/env bash

echo "Beginning with Fedora setup. Have a walk while the machine is setup"

# Upgrade the already present packages
sudo dnf -y upgrade

# Install zsh
sudo dnf -y install zsh

# Install everything else
sudo dnf -y install ack
sudo dnf -y install git git-extras hub 
sudo dnf -y install htop ngrep nmap
sudo dnf -y install autojump
pip install legit
legit install		 # Enables the extra git commands
sudo dnf -y install zopfli
sudo dnf -y install cowsay
# ngrok ,pup, editorconfig
sudo dnf -y install sshrc
pip install stormssh
pip install --user howdoi
sudo dnf -y install httpie
sudo dnf -y install jq
sudo dnf -y install elixir

###############################################################################
 
#Install utilities

###############################################################################

sudo dnf -y install firefox
#Evernote,skitch,dash not available
sudo dnf -y install https://prerelease.keybase.io/keybase_amd64.rpm
#android-file-transfer-linux http://whoozle.github.io/android-file-transfer-linux/
#sudo dnf -y install chromium
#sudo dnf -y install hexchat
sudo dnf -y install dropbox
sudo dnf -y install vlc
# nvalt alternative nvpy for notes https://github.com/cpbotha/nvpy

# Postgres Database
sudo dnf -y install postgresql-server
sudo dnf -y install postgresql
sudo dnf -y install pgadmin3
sudo dnf -y install rubygems
sudo gem install pg

# PG tools 
# osgeo needs epel
sudo dnf -y install postgis

################################################################################

#                           Datat Stores
################################################################################

sudo dnf -y install mysql
sudo dnf -y install mongodb
sudo dnf -y install redis
sudo dnf -y install elasticsearch

################################################################################
#                           Dev tools

################################################################################
sudo dnf -y install virtualbox
sudo dnf -y install vagrant
sudo dnf -y install python-postman

sudo dnf -y install weechat
sudo dnf -y install tmux
pip install --user cookiecutter

#Frontend stuff
sudo dnf -y install npm
npm i -g postcss-cli
npm i -g autoprefixer

#Custom stuff
#Telegram
sudo dnf -y copr enable rommon/telegram
sudo dnf -y install telegram-desktop
sudo dnf copr disable rommon/telegram
#Slack needs to be unpacked manually

################################################################################
#                           Customize Shell                                    #
################################################################################

install_oh_my_zsh () {
    # Test to see if zshell is installed.  If it is:
    if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
        # Install Oh My Zsh if it isn't already present
        if [[ ! -d $dir/oh-my-zsh/ ]]; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        fi
        # Set the default shell to zsh if it isn't currently set to zsh
        if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
            chsh -s $(which zsh)
        fi
    else
        # If zsh isn't installed, get the platform of the current machine
        platform=$(uname);
        # If the platform is Linux, try an apt-get to install zsh and then recurse
        if [[ $platform == 'Linux' ]]; then
            if [[ -f /etc/redhat-release ]]; then
                sudo yum install zsh
            fi
            if [[ -f /etc/debian_version ]]; then
                sudo apt-get install zsh
            fi
        # If the platform is OS X, tell the user to install zsh :)
        elif [[ $platform == 'Darwin' ]]; then
            echo "We'll install zsh, then re-run this script!"
            brew install zsh
            exit
        fi
    fi
}

install_oh_my_zsh

###############################################################################
# Zsh                                                                         #
###############################################################################

set -P
# Install Zsh settings
ln -sf $PWD/zsh/themes/curiouslearner.zsh-theme $HOME/.oh-my-zsh/themes
# Zsh Syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install Powerlevel9k theme
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

exit 0
