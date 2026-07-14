# Load ~/.exports, ~/.aliases and ~/.functions
# (~/.extra holds the shell greeting; it's sourced from ~/.zshrc above the p10k
#  instant prompt block, so it must NOT be re-sourced here.)
for file in ~/.{exports,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
unset file

# Detect and load OS specific settings
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   [ -r ~/.linux ] && source ~/.linux
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   [ -r ~/.freebsd ] && source ~/.freebsd
elif [[ "$unamestr" == 'Darwin' ]]; then
   [ -r ~/.osx ] && source ~/.osx
fi

export PATH="$HOME/.cargo/bin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Fabric AI bootstrap
if [ -f "$HOME/.config/fabric/fabric-bootstrap.inc" ]; then . "$HOME/.config/fabric/fabric-bootstrap.inc"; fi
