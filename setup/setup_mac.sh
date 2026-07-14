#!/bin/bash

#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

echo "Running Mac setup. This would take a while. Please sit back and relax."

# Ask for sudo password upfront and keep it alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew
if test ! "$(command -v brew)"
then
  echo "Installing Homebrew for you."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # A fresh install doesn't update this script's own PATH (Apple Silicon uses
  # /opt/homebrew, Intel uses /usr/local) -- without this, every brew call
  # below fails with "command not found" on a first-time machine.
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# gum powers the interactive group picker below
brew install gum

# Utility function to install cask formulas
function installcask() {
    if brew info --cask "${@}" | grep "Not installed" > /dev/null; then
        brew install --cask "${@}"
    else
        echo "$* is already installed."
    fi
}

###############################################################################
# Core (always installed on every machine)                                   #
###############################################################################

install_core() {
    # Install GNU core utilities (those that come with OS X are outdated)
    brew install coreutils
    echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."

    # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
    brew install findutils

    # Install Bash 4
    brew install bash
    brew install zsh zsh-completions
    brew install shellcheck

    # Install wget and curl
    brew install wget
    brew install curl
    # Install GNU `sed`
    # brew install gnu-sed

    # Use `assume` for cloud tasks
    brew tap common-fate/granted
    brew install chamber  # CLI for managing secrets through AWS SSM Parameter Store

    # Install everything else
    # installcask sublime-text
    # installcask visual-studio-code
    installcask zed
    brew install openssl
    brew install ack
    brew install git git-extras gh git-ftp git-crypt
    brew install icdiff  # side-by-side colored diff, ships the `git-icdiff` wrapper
    brew install git-archive-all  # git archive including submodules
    brew install rename htop tree ngrep mtr nmap
    brew install autojump
    # brew install Zopfli     # https://code.google.com/p/zopfli/
    brew install fortune cowsay
    # brew tap heroku/brew && brew install heroku
    # brew install node
    installcask ngrok       # https://ngrok.com/  2.x available from Cask now
    # brew install sshrc      # https://github.com/Russell91/sshrc
    brew install storm      # https://github.com/emre/storm
    # brew install pup        # https://github.com/EricChiang/pup
    brew install httpie     # https://github.com/jakubroztocil/httpie
    brew install jq         # https://stedolan.github.io/jq/
    brew install python3
    brew install editorconfig
    brew install ssh-copy-id  # http://linux.die.net/man/1/ssh-copy-id
    # brew install elixir
    installcask amethyst  # Tiling manager for Mac OSX (cask, not formula)
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
    # brew install granted

    # For translation stuff
    brew install gettext

    # Python packages (pip is included with Python 3 from brew)
    pip3 install -r "$(dirname "$0")/requirements.pip"
}

###############################################################################
# Optional groups                                                            #
###############################################################################

install_cloud() {
    brew install awscli
    brew install aws-vault
    brew install awsume
    brew install aws-cdk
    brew tap aws/tap && brew install copilot-cli
    brew install azure-cli
    brew install doppler
    brew install infracost
    brew install terragrunt
    brew install cloudflared
    brew install flyctl
    brew install supabase
    brew install ansible
    brew install circleci
}

install_languages() {
    brew install mise  # Polyglot runtime manager (node/python/etc.), replaces nvm
    brew install rust
    brew install ruby@3.0
    brew install openjdk@17
    brew install uv
    brew install pdm
    brew install pip-tools
    brew install virtualenv
    brew install yarn
}

install_cli_extras() {
    brew install just
    brew install bb-cli  # Bitbucket CLI, used by the bb-inline-review skill
    brew install hub
    brew install git-lfs
    brew install hadolint
    brew install imagemagick
    brew install pandoc
    brew install scc
    brew install yt-dlp
    brew install rclone
    brew install hugo
}

install_databases() {
    # Postgres Database
    brew install postgresql@14
    installcask pgadmin4
    brew services start postgresql@14
    # Wait for postgres to start before running psql
    sleep 3
    psql postgres -c 'CREATE EXTENSION IF NOT EXISTS "adminpack";' 2>/dev/null || true
    gem install pg

    # PG tools needed for every other project:
    brew tap osgeo/osgeo4mac
    brew install gdal
    brew install postgis

    brew install mysql
    # brew tap mongodb/brew
    # brew install mongodb-community
    # brew install mongosh
    brew install redis
    # brew install elasticsearch
}

install_dev_tools() {
    # installcask virtualbox
    # installcask vagrant
    # installcask postman
    installcask bruno
    installcask insomnia

    # New Docker for Mac. For older version run `brew install docker`
    # installcask docker
    # dive is for inspecting docker images
    brew install dive

    brew install orbstack  # Orbstack replacement for Docker.

    # Kubernetes stuff
    brew install minikube
    brew install kubie
    brew install kind
    # brew install buildpacks/tap/pack
    brew install skaffold
    # brew install datawire/blackbird/telepresence2
    brew install k9s
    brew install kubebuilder
    brew install tilt

    brew install diff-so-fancy
    brew link xz && brew install weechat
    brew install tmux
    brew install cookiecutter

    # Some frontend stuff
    npm i -g postcss-cli
    npm i -g autoprefixer
}

install_personal_apps() {
    installcask clipy  # Clipboard history, default hotkey cmd+shift+v
    brew install bat  # Powered cat command with syntax highlighting
    installcask gcc-arm-embedded  # for 2FA
    installcask firefox
    installcask claude
    installcask claude-code
    # installcask evernote
    # installcask keybase
    installcask android-file-transfer
    installcask google-chrome
    # installcask utorrent
    # installcask limechat
    installcask tunnelbear
    # installcask flux
    # installcask dropbox
    installcask iterm2
    installcask numi  # http://numi.io/
    installcask skitch  # https://evernote.com/skitch/
    installcask vlc
    # installcask nvalt  # for notes
    # installcask dash  # awesome offline docs
    # installcask boostnote # https://boostnote.io/#download
    installcask agenda  # cask, not formula
    installcask calibre # converting ebooks in different formats
    # installcask qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webp-quicklook suspicious-package && qlmanage -r
    installcask mounty  # For mounting external NTFS disk in rw mode on MacOS

    # Fonts
    installcask font-source-code-pro

    # Telegram
    installcask telegram
    # TeamViewer
    installcask teamviewer
    # Slack
    installcask slack
    # LastPass CLI
    # brew install lastpass-cli --with-pinentry
    installcask 1password
    installcask bitwarden
    # Install howdoi CLI tool
    pip3 install howdoi
    brew install tor
    installcask spotify
}

###############################################################################
# Group selection                                                            #
###############################################################################
#
# Core always installs. Everything else is picked interactively, so a given
# machine only gets what it actually needs. Set SETUP_MAC_ALL=1 to skip the
# prompt and install every group (useful for CI or a from-scratch clone).

GROUP_LABELS=(
    "Cloud & Infra (AWS/Azure/CI)"
    "Languages & Runtimes (mise/rust/ruby/uv)"
    "Everyday CLI extras (just/bb-cli/hugo/...)"
    "Databases (postgres/mysql/redis)"
    "Dev tools (containers, Kubernetes, tmux)"
    "Personal apps & utilities (browsers, chat, casks)"
)
GROUP_FUNCS=(
    install_cloud
    install_languages
    install_cli_extras
    install_databases
    install_dev_tools
    install_personal_apps
)

install_core

if [ "$SETUP_MAC_ALL" = "1" ] || ! command -v gum >/dev/null 2>&1; then
    [ "$SETUP_MAC_ALL" != "1" ] && echo "gum unavailable, installing every group."
    selected_labels=$(printf '%s\n' "${GROUP_LABELS[@]}")
else
    selected_labels=$(printf '%s\n' "${GROUP_LABELS[@]}" | gum choose --no-limit \
        --header "Optional groups to install (space to toggle, enter to confirm):")
fi

while IFS= read -r label; do
    [ -z "$label" ] && continue
    for i in "${!GROUP_LABELS[@]}"; do
        if [ "${GROUP_LABELS[$i]}" = "$label" ]; then
            "${GROUP_FUNCS[$i]}"
        fi
    done
done <<< "$selected_labels"

################################################################################
#                           Customize Shell                                    #
################################################################################

install_oh_my_zsh () {
    # Test to see if zshell is installed.  If it is:
    if [ -f /bin/zsh ] || [ -f /usr/bin/zsh ]; then
        # Install Oh My Zsh if it isn't already present
        if [[ ! -d $HOME/.oh-my-zsh/ ]]; then
            # Use RUNZSH=no to prevent oh-my-zsh from launching a new shell
            # Use CHSH=no to skip changing shell (we'll do it at the end)
            RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        fi
    else
        # If zsh isn't installed, get the platform of the current machine
        platform=$(uname);
        # If the platform is Linux, try an apt-get to install zsh and then recurse
        if [[ $platform == 'Linux' ]]; then
            if [[ -f /etc/redhat-release ]]; then
                sudo yum install -y zsh
            fi
            if [[ -f /etc/debian_version ]]; then
                sudo apt-get install -y zsh
            fi
        # If the platform is OS X, install zsh via brew and continue
        elif [[ $platform == 'Darwin' ]]; then
            echo "Installing zsh via Homebrew..."
            brew install zsh
        fi
        # Recurse to install oh-my-zsh now that zsh is installed
        install_oh_my_zsh
    fi
}

install_oh_my_zsh

###############################################################################
# Zsh                                                                         #
###############################################################################

# Zsh Syntax highlighting
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Install PowerLevel10k theme
if [[ ! -d "$HOME/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
fi

# Create symlinks for zshrc and p10k.zsh config
# Backup existing files if they exist and are not symlinks
[[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
[[ -f "$HOME/.p10k.zsh" && ! -L "$HOME/.p10k.zsh" ]] && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak"
ln -sf "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
ln -sf "$HOME/dotfiles/.p10k.zsh" "$HOME/.p10k.zsh"

# Install fonts for PowerLevel10k
mkdir -p "$HOME/Library/Fonts"
curl -fLo "$HOME/Library/Fonts/MesloLGS NF Bold Italic.ttf" --create-dirs \
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
curl -fLo "$HOME/Library/Fonts/MesloLGS NF Regular.ttf" \
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
curl -fLo "$HOME/Library/Fonts/MesloLGS NF Italic.ttf" \
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
curl -fLo "$HOME/Library/Fonts/MesloLGS NF Bold.ttf" \
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"


# Remove outdated versions from the cellar
brew cleanup

# Change default shell to zsh at the very end
if [[ ! "$SHELL" == $(command -v zsh) ]]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(command -v zsh)"
fi

echo ""
echo "=========================================="
echo "Setup complete!"
echo "=========================================="
echo ""
echo "Restart your terminal (or run: exec zsh) to use zsh."
echo ""

exit 0
