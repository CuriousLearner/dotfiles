# Load ~/.extra, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{exports,aliases,functions,extra}; do
    [ -r "$file" ] && source "$file"
done
unset file

# Detect and load OS specific settings
platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   [ -r ~/.linux ] && source ~/.linux
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   [ -r ~/.freebsd ] && source ~/.freebsd
elif [[ "$unamestr" == 'Darwin' ]]; then
   [ -r ~/.osx ] && source ~/.osx
fi

# Check for startup SPLASH script (skip if P10k instant prompt is active)
if hash splash 2>/dev/null && [[ -z "$POWERLEVEL9K_INSTANT_PROMPT" ]]; then
    splash
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$HOME/.cargo/bin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export PATH="$PATH:$HOME/Downloads/flutter/bin"
