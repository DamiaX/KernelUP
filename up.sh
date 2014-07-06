#!/bin/bash

#Copyright © 2014 Damian Majchrzak (DamiaX)
#http://damiax.github.io/kernelup/

url="https://raw.githubusercontent.com/DamiaX/kernelup/master/kernelup.sh";
temp=".temp";
name="kernelup";

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
sudo rm -rf kernelup*;

rm -rf $temp;

wget -q $url -O $name;
chmod +x $name;
./$name -c -y;
exit;
