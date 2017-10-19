#!/bin/bash

#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /tmp/homebrew-install.log
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash
brew install zsh zsh-completions

# Install wget with IRI support
brew install wget --with-iri
brew install curl --with-ssl --with-ssh
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep
brew tap josegonzalez/homebrew-php

# Install everything else
brew install openssl
brew install ack
brew install git git-extras hub git-ftp git-crypt
brew install rename htop-osx tree ngrep mtr nmap
brew install autojump
brew install legit      # http://www.git-legit.org/
brew install Zopfli     # https://code.google.com/p/zopfli/
brew install fortune cowsay
brew install heroku-toolbelt
brew install node
brew install ngrok      # https://ngrok.com/
brew install sshrc      # https://github.com/Russell91/sshrc
brew install storm      # https://github.com/emre/storm
brew install pup        # https://github.com/EricChiang/pup
brew install httpie     # https://github.com/jakubroztocil/httpie
brew install jq         # https://stedolan.github.io/jq/
brew install python3
brew install editorconfig
brew install ssh-copy-id  # http://linux.die.net/man/1/ssh-copy-id
brew install elixir

# Native apps
brew tap phinze/homebrew-cask
brew install brew-cask
function installcask() {
    if brew cask info "${@}" | grep "Not installed" > /dev/null; then
        brew cask install "${@}"
    else
        echo "${@} is already installed."
    fi
}

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
                install_zsh
            fi
            if [[ -f /etc/debian_version ]]; then
                sudo apt-get install zsh
                install_zsh
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

# Install Zsh settings
ln -s $PWD/zsh/themes/curiouslearner.zsh-theme $HOME/.oh-my-zsh/themes

###############################################################################
# Install utilities                                                           #
###############################################################################

installcask android-file-transfer
installcask google-chrome
installcask utorrent
# installcask limechat
installcask tunnelbear
installcask flux
installcask dropbox
installcask iterm2
installcask numi  # http://numi.io/
installcask skitch  # https://evernote.com/skitch/
installcask vlc
installcask nvalt  # for notes
installcask qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webp-quicklook suspicious-package && qlmanage -r

# Postgres 9 Database
brew install postgres
installcask pgadmin3
# ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
# launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
psql postgres -c 'CREATE EXTENSION "adminpack";'
sudo gem install pg

# PG tools needed for every other project:
brew tap osgeo/osgeo4mac
brew install gdal
brew install postgis

# Fonts
brew tap caskroom/fonts

brew cask install font-source-code-pro

sudo easy_install pip
sudo pip install -r requirements.pip

################################################################################
#                       Data Stores                                            #
################################################################################

brew install mysql
brew install mongo
brew install redis
brew install elasticsearch

################################################################################
#                           Dev tools                                          #
################################################################################

brew install diff-so-fancy
brew link xz && brew install weechat
brew cask install sublime-text
brew install tmux

# Install custom stuff
# Telegram
brew cask install telegram
# Slack
brew cask install slack

# Remove outdated versions from the cellar
brew cleanup && brew cask cleanup

exit 0
