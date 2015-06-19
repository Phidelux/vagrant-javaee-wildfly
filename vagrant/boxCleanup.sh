#!/bin/bash

# Remove outdated kernel(s) ...
dpkg -l linux-* | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e [0-9] | grep -E "(image|headers)" | xargs apt-get -y purge

# ... and update grub.
update-grub

# Remove outdated packages.
apt-get -y autoremove
