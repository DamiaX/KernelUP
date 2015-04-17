#!/bin/bash

#Copyright © 2015 Damian Majchrzak (DamiaX)
#http://damiax.github.io/kernelup/

temp=".temp";

ps -e | grep 'kernelup-init' >$temp

if [ -s $temp ]
 then
killall 'sleep'; 
killall kernelup-init;
fi

sudo rm -rf /tmp/kernelup*; 
sudo rm -rf /usr/share/icons/hicolor/128x128/apps/kernelup.png; 
sudo rm -rf ~/.config/autostart/kernelup*;
sudo rm -rf /usr/local/sbin/kernelup*; 
sudo rm -rf /usr/share/applications/kernelup*;
sudo rm -rf $HOME/.KernelUP_data;
sudo rm -rf kernelup*; 
rm -rf $temp;

sudo rm -rf $0;

exit;
