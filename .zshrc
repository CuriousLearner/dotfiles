# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


ZSH=$HOME/.oh-my-zsh
# Theme is sourced directly from ~/powerlevel10k below
ZSH_THEME=""
source "$ZSH/oh-my-zsh.sh"

# Customizations goes below
source ~/.profile

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

HISTFILE=~/.histfile
# HISTSIZE and SAVEHIST are set in .exports (32768)
# Uncomment below to override:
# HISTSIZE=5000
# SAVEHIST=5000
bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey "\e[B" history-search-forward
bindkey "\e[A" history-search-backward
export PATH="/usr/local/opt/gettext/bin:$PATH"

# RVM PATH is already set in .profile, no need to duplicate here

# Enable buildpack `packs` completion for docker
command -v pack >/dev/null && . "$(pack completion --shell zsh)"

# Load Powerlevel10k theme
[[ -f ~/powerlevel10k/powerlevel10k.zsh-theme ]] && source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -U +X bashcompinit && bashcompinit
# Terraform completion - auto-detect path for Intel/Apple Silicon Macs
if command -v terraform &>/dev/null; then
  complete -o nospace -C "$(which terraform)" terraform
fi

# Sign commits via GPG
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1 || true

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# BEGIN SNIPPET: Platform.sh CLI configuration
export PATH="$HOME/.platformsh/bin:$PATH"
if [ -f "$HOME/.platformsh/shell-config.rc" ]; then . "$HOME/.platformsh/shell-config.rc"; fi # END SNIPPET

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
[ -x ~/.local/bin/mise ] && eval "$(~/.local/bin/mise activate zsh)"
if [ -f "$HOME/.config/fabric/fabric-bootstrap.inc" ]; then . "$HOME/.config/fabric/fabric-bootstrap.inc"; fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

