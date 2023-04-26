#!/bin/bash

remotes=(
  "flathub https://flathub.org/repo/flathub.flatpakrepo"
  "kdeapps https://distribute.kde.org/kdeapps.flatpakrepo"
  "gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo"
  "fedora oci+https://registry.fedoraproject.org"
)

for remote in "${remotes[@]}"; do
  read -p "Do you want to add $remote to Flatpak? (y/n) " answer
  if [ "$answer" = "y" ]; then
    flatpak remote-add --if-not-exists ${remote%% *} ${remote#* }
  fi
done

