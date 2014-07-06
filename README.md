KernelUP
========
**KernelUP** is a program to automatically update the kernel for **Ubuntu** and **Linux Mint**.

Features:
==========

* Autostart.
* Automatically checking for kernel version.
* Notifications about new kernel version.
* Automatic updates KernelUP.
* The translations (Polish and English).
* Removing older versions of the kernel.
* System Plugin.

Installation KernelUP:
=============
* Execute this command from terminal(one liner):

  `sudo rm -rf /usr/local/sbin/kernelup*;  wget -q --no-cache --no-check-certificate https://raw.githubusercontent.com/DamiaX/kernelup/master/kernelup.sh -O kernelup; chmod +x kernelup; sudo ./kernelup`
  
Or:

* Download [this](https://raw.githubusercontent.com/DamiaX/kernelup/master/kernelup.sh) file -- `wget --no-cache -q https://raw.githubusercontent.com/DamiaX/kernelup/master/kernelup.sh -O kernelup.sh`, give permissions to run -- `chmod +x kernelup.sh` and run as root this file on terminal -- `sudo kernelup.sh`

Uninstall KernelUP:
=========
* Execute this command from terminal(one liner):
  
  `sudo rm -rf /tmp/kernelup*; sudo rm -rf /usr/share/icons/hicolor/128x128/apps/kernelup.png; sudo rm -rf ~/.config/autostart/kernelup-init.desktop; sudo rm -rf /usr/local/sbin/kernelup*; sudo rm -rf /usr/share/applications/kernelup-init.desktop; sudo rm -rf $HOME/.KernelUP_data`
      
or:

* Execute this command from terminal:
 
  `sudo kernelup -r`

Create and install Plugin for KernelUP
=====================================

Install Plugin:
--------------
* To install the plugin just move it to the directory: "~/.KernelUP_data/Plugins/" -- `mv PLUGIN_NAME.kernelup $HOME/.KernelUP_data/Plugins/`

Create Plugin:
--------------
* Download a [ sample ] (https://raw.githubusercontent.com/DamiaX/KernelUP/master/Plugins/example.kernelup) plugin. -- `wget --no-cache -q https://raw.githubusercontent.com/DamiaX/KernelUP/master/Plugins/example.kernelup` and see its structure.

Author: 
=======
**Damian Majchrzak** [DamiaX](https://www.facebook.com/DamiaX)**.**
