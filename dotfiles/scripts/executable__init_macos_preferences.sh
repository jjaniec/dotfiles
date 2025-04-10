#!/bin/bash

# Set macos verbose mode at boot
sudo nvram boot-args="-v"

# Set sped up key repeat rate
defaults write -g KeyRepeat -int 1

# Set dock icon size to minimum
defaults write com.apple.dock tilesize -int 16
