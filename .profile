# Load ~/.extra, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{exports,aliases,functions,extra}; do
    [ -r "$file" ] && source "$file"
done
unset file

# Detect and load OS specific settigs
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   source ~/.linux
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   source ~/.freebsd
elif [[ "$unamestr" == 'Darwin' ]]; then
   source ~/.osx
fi

# Check for startup SPLASH script
if hash splash 2>/dev/null; then
    splash
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$HOME/.cargo/bin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
