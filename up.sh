#!/bin/bash

#Copyright © 2014 Damian Majchrzak (DamiaX)
#http://damiax.github.io/kernelup/

url="https://raw.githubusercontent.com/DamiaX/kernelup/master/kernelup.sh";
temp=".temp";
temp1=".temp1";
name="kernelup";

ps -e | grep 'kernelup-init' >$temp
ps -e | grep 'kernelup-run' >$temp1

if [ -s $temp ]
 then
killall kernelup-init;
fi

if [ -s $temp1 ]
 then
killall kernelup-run;
fi

sudo rm -rf /tmp/kernelup*; 
sudo rm -rf /usr/share/icons/hicolor/128x128/apps/kernelup.png; 
sudo rm -rf ~/.config/autostart/kernelup-init.desktop; 
sudo rm -rf /usr/local/sbin/kernelup*; 
sudo rm -rf /usr/share/applications/kernelup-init.desktop;
sudo rm -rf kernelup*;

rm -rf $temp;
rm -rf $temp1;

wget -q $url -O $name;
chmod +x $name;
./$name;
exit;
