#!/bin/bash

set -eu

ARCH_PACKAGES=(git nodejs npm)
ARCH_PACKAGES+=(python-pyqt5 python-pyqt5-sip python-pyqtwebengine wmctrl xdotool)
ARCH_PACKAGES+=(python-qrcode aria2 python-qtconsole)

# System dependencies
if apt -v &> /dev/null; then
    sudo apt -y install git nodejs npm aria2 wmctrl xdotool
    sudo apt -y install libglib2.0-dev
    # Missing in Ubuntu: filebrowser-bin

    sudo apt -y install python3-pyqt5 python3-sip python3-pyqt5.qtwebengine \
         python3-qrcode python3-feedparser \
         python3-markdown python3-qtconsole python3-pygit2

elif dnf &> /dev/null; then
    sudo dnf -y install git nodejs npm aria2 wmctrl xdotool
    sudo dnf -y install glib2-devel
    # TODO: please add filebrowser-bin if it exists in Fedora repo.

    sudo dnf -y install python3-pyqt5-sip pyqtwebengine-devel python3-qrcode \
         python3-feedparser python3-markdown \
         python3-qtconsole python3-pygit2

elif type pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm --needed "${ARCH_PACKAGES[@]}"
    if type yay &> /dev/null; then
        yay -S --noconfirm filebrowser-bin
    fi
else
    echo "Unsupported distribution/package manager. Here are the packages that needs to be installed:"
    for PCK in "${ARCH_PACKAGES[@]}";
    do
        echo "- ${PCK}"
    done
    echo "Please test their installation and submit an issue/PR to https://github.com/manateelazycat/emacs-application-framework for the script to be updated."
    exit 1
fi

echo "Installing npm dependencies..."
npm install

# Python dependencies
if type pip3 &>/dev/null; then
    pip3 install --user pymupdf epc retrying
elif type pip &>/dev/null; then
    pip install --user pymupdf epc retrying
else
    echo "Cannot find pip. Please install it before launching the script again."
    exit 1
fi
