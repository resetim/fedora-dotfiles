#!/bin/env bash

#Update and upgrade distro
sudo dnf update

#Install RPM free and non-free repositories 
#Free
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

#Non-Free
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

PROGRAMS_INSTALL=(
	tilix
	zsh
	zsh-autosuggestions
	zsh-syntax-highlighting
	neofetch
	htop
	gcc
	dkms
	kernel-headers
	kernel-devel
	bzip2
	make
	curl
	akmod-nvidia
	xorg-x11-drv-nvidia
	xorg-x11-drv-nvidia-libs
	xorg-x11-drv-nvidia-libs.i686
	mangohud
	lutris
	wine
	bpytop
	intel-undervolt
	@virtualization
	obs-studio
	virtualbox
	virtualbox-guest-additions
	vim
	dnf-plugins-core
)

#SCRIPT
for name_of_program in ${PROGRAMS_INSTALL[[@]]};do
	if ! dnf repoquery | grep -q $name_of_program; then
		dnf install "$name_of_program"
	else
		echo "[Already installed]" - $name_of_program
	fi
done

#additional virt options
sudo dnf group install --with-optional virtualization

#Change Shell
chsh -s $(which zsh)

#libvirtd
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

#virtualbox
sudo systemctl enable vboxservice
sudo systemctl start vboxservice
sudo usermod -a -G vboxusers $USER
newgrp vboxusers

#Nvidia Configurations
sudo akmods --force
sudo dracut --force

#Gstream and multimedia
sudo dnf group upgrade --with-optional Multimedia
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install lame\* --exclude=lame-devel

#Flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#Brave
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser

#Steam Launch Options
#__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only mangohud gamemoderun %command%

#Mobile Passthrough scripts test
git clone https://github.com/T-vK/MobilePassThrough.git
