#!/bin/bash

USR=$SUDO_USER

if [ "$USR" == "" ]; then
  echo "This script must be run as root"
  exit 0
fi

apt-get update -y # To get the latest package lists
apt-get upgrade -y
apt-get install -y fonts-indic
apt-get install -y --no-install-recommends chromium-browser
apt-get install -y --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox # Graphical user interface
apt-get install -y unclutter
apt-get install -y pulseaudio
apt-get install -y pavucontrol 
#apt-get install network-manager
#apt-get install network-manager-gnome


usermod -a -G audio gscdcl
usermod -a -G video gscdcl



#Setup Automatic logon Begin ::


#Create File/Directory if not Exists
[ ! -d /etc/systemd/system/getty@tty1.service.d ] && mkdir -p /etc/systemd/system/getty@tty1.service.d
[ ! -f /etc/systemd/system/getty@tty1.service.d/override.conf ] && touch /etc/systemd/system/getty@tty1.service.d/override.conf

cat > /etc/systemd/system/getty@tty1.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty -a gscdcl --noclear %I \$TERM
EOF
#Setup Automatic logon End


#Setup autostart Begin
cat > /etc/xdg/openbox/autostart <<EOF

# Disable any form of screen saver / screen blanking / power management
xset s off
xset s noblank
xset -dpms

# Allow quitting the X server with CTRL-ATL-Backspace
setxkbmap -option terminate:ctrl_alt_bksp
@unclutter -idle 0.1 

# Start Chromium in kiosk mode
chromium-browser --disable-infobars --kiosk 'https://www.google.com/'
EOF

#Setup autostart End


#Setup Autostart Graphical user interface Begin ::
cd

echo '[[ -z \$DISPLAY && \$XDG_VTNR -eq 1 ]] && startx' >>~/.bash_profile
#sudo cat > .bash_profile <<EOF
#[[ -z \$DISPLAY && \$XDG_VTNR -eq 1 ]] && startx
#EOF
#Setup Autostart Graphical user interface End


sudo tee -a /etc/hosts > /dev/null <<EOT
192.168.20.2 museum.gwaliorsmartcity.org
EOT


