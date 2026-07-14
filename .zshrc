# Sign commits via GPG - must be before P10k instant prompt for pinentry to work
export GPG_TTY=$(tty)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


ZSH=$HOME/.oh-my-zsh
# Theme is sourced directly from ~/powerlevel10k below
ZSH_THEME=""
# Add Docker CLI completions to fpath before oh-my-zsh runs compinit.
fpath=($HOME/.docker/completions $fpath)
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

# node is managed by mise (activated below); nvm removed to keep startup fast.

# BEGIN SNIPPET: Platform.sh CLI configuration
export PATH="$HOME/.platformsh/bin:$PATH"
if [ -f "$HOME/.platformsh/shell-config.rc" ]; then . "$HOME/.platformsh/shell-config.rc"; fi # END SNIPPET

# conda: lazy-loaded, no base auto-activation, so it costs nothing at startup.
# First `conda ...` call initializes it, then hands off to the real conda.
conda() {
  unset -f conda
  eval "$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook')"
  conda "$@"
}

# PostgreSQL - dynamically find installed version
for pg in /opt/homebrew/opt/postgresql@*/bin; do
  [ -d "$pg" ] && export PATH="$pg:$PATH" && break
done
command -v mise >/dev/null && eval "$(mise activate zsh)"

# kubectl completion
source <(kubectl completion zsh)

