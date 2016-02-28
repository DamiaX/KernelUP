#!/bin/bash

#Copyright © 2016 Damian Majchrzak (DamiaX)
#http://damiax.github.io/kernelup/

url="https://raw.githubusercontent.com/DamiaX/kernelup/master/kernelup.sh";
remove_url="https://raw.githubusercontent.com/DamiaX/KernelUP/master/Core/remove.sh"
name="$1";
remove_name=".remove.sh"

wget -q $remove_url -O $remove_name;
chmod +x $remove_name;
./$remove_name;

wget -q $url -O $name;
chmod +x $name;
sudo $name -iu;
rm -rf $0;
exit;
