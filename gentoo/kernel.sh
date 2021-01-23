#!/bin/bash
# run as root

emerge --sync
emerge --ask --update --deep --with-bdeps=y --newuse @world
emerge --ask sys-kernel/gentoo-sources
emerge --ask sys-kernel/genkernel
eselect kernel list
echo "choose your kernel"
read kernel_set
eselect kernel set $kernel_set
cd /usr/src/linux
make clean
genkernel --install all
grub-mkconfig -o /boot/grub/grub.cfg
