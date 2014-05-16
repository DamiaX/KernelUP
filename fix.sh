#!/bin/bash

#Copyright © 2014 Damian Majchrzak (DamiaX)
#http://damiax.github.io/kernelup/
#Fix system update in KernelUP 0.3.*


if [ "$(id -u)" != "0" ]; then
echo "Root permissions are required." 1>&2
   exit 1
fi
}

sed -i 's@-le@-eq@g' /usr/local/sbin/kernelup*
