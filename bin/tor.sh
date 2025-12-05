#!/usr/bin/env bash

# 'Wi-Fi' or 'Ethernet' or 'Display Ethernet'
INTERFACE=Wi-Fi

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# trap ctrl-c and call disable_proxy()
function disable_proxy() {
    sudo networksetup -setsocksfirewallproxystate "$INTERFACE" off
    tput setaf 64 #green
    echo "SOCKS proxy disabled."
    tput sgr0 # color reset
}
trap disable_proxy INT

# Let's roll
sudo networksetup -setsocksfirewallproxy "$INTERFACE" 127.0.0.1 9050 off
sudo networksetup -setsocksfirewallproxystate "$INTERFACE" on

tput setaf 64 # green
echo "SOCKS proxy 127.0.0.1:9050 enabled."
tput setaf 136 # orange
echo "Starting Tor..."
tput sgr0 # color reset

tor
