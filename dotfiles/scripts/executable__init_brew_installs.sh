#!/bin/bash

set +o errexit

sudo ls

packages=(asdf awscli notify rclone)

for i in "${packages[@]}"; do
  brew fetch "$i" &
done
wait
brew install \
  asdf \
  awscli \
  notify \
  rclone \
  vim \
  nano \
  git \
  jq \
  yq

casks=(iterm2 beeper discord lunar aldente swift-quit superwhisper visual-studio-code notion notion-calendar cursor microsoft-outlook vivaldi hazeover spotify megasync slack appcleaner vlc microsoft-teams alt-tab raycast chatgpt kap cloudflare-warp tailscale macfuse devtoys)

for i in "${casks[@]}"; do
  brew fetch --cask "$i" &
done
wait

for i in ${casks[@]}; do
  echo "Installing $i"
  brew install --cask "$i"
done

# brew install --cask \
#   iterm2 \
#   beeper \
#   discord \
#   lunar \
#   aldente \
#   swift-quit \
#   superwhisper \
#   visual-studio-code \
#   notion \
#   notion-calendar \
#   cursor \
#   microsoft-outlook \
#   vivaldi \
#   hazeover \
#   spotify \
#   megasync \
#   slack \
#   appcleaner \
#   vlc \
#   microsoft-teams \
#   alt-tab \
#   raycast \
#   chatgpt \
#   kap \
#   cloudflare-warp \
#   tailscale \
#   macfuse

  # linear

# https://www.docker.com/products/docker-desktop/
