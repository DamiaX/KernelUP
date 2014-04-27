KernelUP
========

Functions:
==========
**[*] Autostart.**

**[*] Automatically checking for kernel version.**
**[*] Notifications about new kernel version.**
**[*] Automatic updates KernelUP.**
**[*] The translations (Polish and English).**

Installation:
=============
Run in Terminal:
----------------

     sudo rm -rf /usr/local/sbin/kernelup*;  wget -q --no-check-certificate https://raw.githubusercontent.com/DamiaX/kernelup/master/kernelup.sh -O kernelup; chmod +x kernelup; sudo ./kernelup
     
Uninstall:
==========
Run in Terminal:
----------------

    sudo rm -rf /tmp/kernelup*; sudo rm -rf /usr/share/icons/hicolor/128x128/apps/kernelup.png; sudo rm -rf ~/.config/autostart/kernelup-init.desktop; sudo rm -rf /usr/local/sbin/kernelup*; sudo rm -rf /usr/share/applications/kernelup-init.desktop;
      
or:
---

     sudo kernelup -r
