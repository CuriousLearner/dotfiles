#!/bin/bash

#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

echo "Running Mac setup. This would take a while. Please sit back and relax."

# Check for Homebrew
if test ! "$(command -v brew)"
then
  echo "Installing Homebrew for you."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."

brew tap homebrew/cask

# Utility function to install cask formulas
function installcask() {
    if brew info --cask "${@}" | grep "Not installed" > /dev/null; then
        brew install --cask "${@}"
    else
        echo "$* is already installed."
    fi
}

# Tap all the cask verision from homebrew
brew tap homebrew/cask-versions

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash
brew install zsh zsh-completions
brew install shellcheck

# Install wget with IRI support
brew install wget --with-iri
brew install curl --with-ssl --with-ssh
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install more recent versions of some OS X tools
brew tap josegonzalez/homebrew-php

# Use `assume` for cloud tasks
brew tap common-fate/granted

# Install everything else
caskinstall sublime-text
brew install visual-studio-code
brew install openssl
brew install ack
brew install git git-extras hub git-ftp git-crypt
brew install rename htop-osx tree ngrep mtr nmap
brew install autojump
brew install legit      # http://www.git-legit.org/
# brew install Zopfli     # https://code.google.com/p/zopfli/
brew install fortune cowsay
brew tap heroku/brew && brew install heroku
brew install node
installcask ngrok       # https://ngrok.com/  2.x available from Cask now
brew install sshrc      # https://github.com/Russell91/sshrc
brew install storm      # https://github.com/emre/storm
# brew install pup        # https://github.com/EricChiang/pup
brew install httpie     # https://github.com/jakubroztocil/httpie
brew install jq         # https://stedolan.github.io/jq/
brew install python3
brew install editorconfig
brew install ssh-copy-id  # http://linux.die.net/man/1/ssh-copy-id
# brew install elixir
brew install amethyst  # Tiling manager for Mac OSX
brew install gpg
brew install sops
brew install age
# brew install hg         # Mercurial for FOSS projects (mainly Mozilla)
# brew install latex2html
brew install pre-commit  # https://pre-commit.com/
brew install libmemcached  # for Django Developement
brew tap hashicorp/tap
brew install terraform
brew install duf  # disk-free usage
brew install tldr  # tldr man-pages
brew install btop  # better than htop
brew install granted  # assume cli

# For translation stuff
brew install gettext

###############################################################################
# Install utilities                                                           #
###############################################################################

brew install clipy  # Amazing extension for clipboard history
brew install bat  # Powered cat command with syntax highlighting
installcask gcc-arm-embedded  # for 2FA
installcask firefox
# installcask evernote
# installcask keybase
installcask android-file-transfer
installcask google-chrome
# installcask utorrent
# installcask limechat
# installcask tunnelbear
# installcask flux
# installcask dropbox
installcask iterm2
installcask numi  # http://numi.io/
installcask skitch  # https://evernote.com/skitch/
installcask vlc
# installcask nvalt  # for notes
# installcask dash  # awesome offline docs
# installcask boostnote # https://boostnote.io/#download
brew install agenda
installcask calibre # converting ebooks in different formats
# installcask qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webp-quicklook suspicious-package && qlmanage -r
installcask mounty  # For mounting external NTFS disk in rw mode on MacOS

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
brew tap homebrew/cask-fonts

installcask font-source-code-pro

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

installcask virtualbox
installcask vagrant
# installcask postman
installcask insomnia

# New Docker for Mac. For older version run `brew install docker`
# installcask docker
# dive is for inspecting docker images
brew install dive
# Kubernetes stuff
brew install minikube
brew install kubie
brew install kind
brew install buildpacks/tap/pack
brew install skaffold
brew install datawire/blackbird/telepresence2

brew install diff-so-fancy
brew link xz && brew install weechat
installcask sublime-text
brew install tmux
brew install cookiecutter

# Some frontend stuff
brew install node
npm i -g postcss-cli
npm i -g autoprefixer

################################################################################
#                           Custom Stuff                                       #
################################################################################

# Telegram
installcask telegram
# TeamViewer
installcask teamviewer
# Slack
installcask slack
# LastPass CLI
# brew install lastpass-cli --with-pinentry
brew install bitwarden
# Install howdoi CLI tool
brew install https://raw.github.com/gleitz/howdoi/master/howdoi.rb
brew install tor
brew install spotify

################################################################################
#                           Customize Shell                                    #
################################################################################

install_oh_my_zsh () {
    # Test to see if zshell is installed.  If it is:
    if [ -f /bin/zsh ] || [ -f /usr/bin/zsh ]; then
        # Install Oh My Zsh if it isn't already present
        if [[ ! -d $HOME/oh-my-zsh/ ]]; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        fi
        # Set the default shell to zsh if it isn't currently set to zsh
        if [[ ! "$SHELL" == $(command -v zsh) ]]; then
            chsh -s "$(command -v zsh)"
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
ln -sf "$PWD"/zsh/themes/curiouslearner.zsh-theme "$HOME"/.oh-my-zsh/themes
# Zsh Syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

## Install PowerLevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# Create symlinks for zshrc and p10k.zsh config
# But backup the current one so that
# symlinks can be created.
mv "/Users/$(whoami)/.zshrc" "/Users/$(whoami)/.zshrc.bak"
mv "/Users/$(whoami)/.p10k.zsh" "/Users/$(whoami)/.p10k.zsh.bak"
ln -s "/Users/$(whoami)/dotfiles/.zshrc" "/Users/$(whoami)/.zshrc"
ln -s "/Users/$(whoami)/dotfiles/.p10k.zsh" "/Users/$(whoami)/.p10k.zsh"

# Install fonts for powerline 10k

test ! -f ~/Library/Fonts/MesloLGS\ NF\ Bold\ Italic.ttf && curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf > ~/Library/Fonts/MesloLGS\ NF\ Bold\ Italic.ttf
test ! -f ~/Library/Fonts/MesloLGS\ NF\ Regular.ttf && curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf > ~/Library/Fonts/MesloLGS\ NF\ Regular.ttf
test ! -f ~/Library/Fonts/MesloLGS\ NF\ Italic.ttf && curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf > ~/Library/Fonts/MesloLGS\ NF\ Italic.ttf
test ! -f ~/Library/Fonts/MesloLGS\ NF\ Bold.ttf && curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf > ~/Library/Fonts/MesloLGS\ NF\ Bold.ttf


# Remove outdated versions from the cellar
brew cleanup && brew cleanup cask

exit 0
