# Make sure to export the appropriate environment variable
# _before_ loading this theme in your ~/.zshrc which makes sure that terminal
# supports more than 256 colors
export TERM="xterm-256color"

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel9k/powerlevel9k"
source $ZSH/oh-my-zsh.sh

POWERLEVEL9K_MODE='awesome-patched'
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv os_icon dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status nvm node_version)

POWERLEVEL9K_OS_ICON_BACKGROUND="white"
POWERLEVEL9K_OS_ICON_FOREGROUND="blue"
POWERLEVEL9K_DIR_HOME_FOREGROUND="white"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="white"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"

# Customizations goes below
source ~/.profile

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
export PATH="/usr/local/opt/node@8/bin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
