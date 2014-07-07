#!/bin/bash

#Copyright © 2014 Damian Majchrzak (DamiaX)
#http://damiax.github.io/kernelup/

version="3.0";
app='kernelup';
version_url="https://raw.githubusercontent.com/DamiaX/kernelup/master/VERSION";
ubuntu_url="http://kernel.ubuntu.com/~kernel-ppa/mainline";
kernelup_run_url="https://raw.githubusercontent.com/DamiaX/KernelUP/master/Core/kernelup-run";
kernelup_pl_url="https://raw.githubusercontent.com/DamiaX/KernelUP/master/Language/kernelup.pl.lang";
kernelup_en_url="https://raw.githubusercontent.com/DamiaX/KernelUP/master/Language/kernelup.en.lang";
kernelup_up="https://raw.githubusercontent.com/DamiaX/kernelup/master/up.sh"
remove_url="https://raw.githubusercontent.com/DamiaX/KernelUP/master/Core/remove.sh";
desktop_url='https://raw.githubusercontent.com/DamiaX/KernelUP/master/Core/kernelup.desktop';
icon_url='https://raw.githubusercontent.com/DamiaX/KernelUP/master/kernelup.png';
init_url='https://raw.githubusercontent.com/DamiaX/KernelUP/master/Core/kernelup-init';
connect_test_url1='google.com';
connect_test_url2='facebook.com';
connect_test_url3='kernel.org';
icon_name='kernelup.png';
init_name='kernelup-init';
desktop_name='kernelup-init.desktop';
remove_name='remove.sh';
script_kernel_remove_name='kernel_remove.sh';
kernelup_run_name='kernelup-run';
temp=".kernel.temp";
temp1=".kernel1.temp";
temp2=".kernel2.temp";
temp3=".kernel3.temp";
temp4=".kernel4.temp";
url=".url.temp";
x64=".x64.link";
x86=".x86.link";
xall=".xall.link";
kat=".install_katalog";
pl='kernelup.pl.lang';
en='kernelup.en.lang';
up='up.sh';
app_dir='/usr/local/sbin';
icon_path='/usr/share/icons/hicolor/128x128/apps';
applications_path='/usr/share/applications/';
actual_dir="$(pwd)";
temp_dir="$HOME/temp_dir";
autostart_dir="$HOME/.config/autostart/";
latest_kernel_installed=$(ls /boot/ | grep img | cut -d "-" -f2 | sort -V | cut -d "." -f1,2,3 | tail -n 1);
log_dir="$HOME/.KernelUP_data";
plugins_dir="$log_dir/Plugins";
plugins_extension="*.kernelup";
log_name="kernelup.klog";
log_name_reboot="kernelup_reboot.log";

data_clear()
{
rm -rf $temp
rm -rf $temp1
rm -rf $temp2
rm -rf $temp3
rm -rf $temp4
rm -rf $url
rm -rf $x64
rm -rf $x86
rm -rf $xall
rm -rf $kat
}

refresh_system()
{
apt-get update -y -qq;
apt-get upgrade -y -qq;	
}

default_answer()
{
if [ -z $answer ]; then
answer='y';l
fi
}

create_app_data()
{
if [ -e $log_dir ] ; then
echo -e -n '';
else
mkdir -p $log_dir;
chmod 777 $log_dir;
fi

if [ -e $plugins_dir ] ; then
echo -e -n '';
else
mkdir -p $plugins_dir;
chmod 777 $plugins_dir;
fi
}

add_chmod()
{
if [ -e $log_dir ] ; then
chmod 777 $log_dir;
fi

if [ -e $plugins_dir ] ; then
chmod 777 $plugins_dir;
fi
}	

load_plugins()
{
NR=1
if [ -f $plugins_dir/ ] ; then
echo -e -n '';
else
for plugins in $plugins_dir/$plugins_extension ; do
grep -h 'function' $plugins_dir/$plugins_extension >$temp
sed -i 's@function@@g' $temp
sed -i 's@ @@g' $temp
ls $plugins_dir/$plugins_extension >$temp2
plugin_name=`cat "$temp2" | sed -n "$NR p"`
function_name=`cat "$temp" | sed -n "$NR p"`
. $plugin_name
$function_name
NR=$[NR + 1]
done
rm -rf $temp
rm -rf $temp
fi
}

langpl()
{
if [ -e $app_dir/$app ] ; then
if [ -e $app_dir/$pl ] ; then
echo -e -n '';
else
wget -q $kernelup_pl_url -O  $app_dir/$pl
fi
else
wget -q $kernelup_pl_url -O  $pl
fi
}

langen()
{
if [ -e $app_dir/$app ] ; then
if [ -e $app_dir/$en ] ; then
echo -e -n '';
else
wget -q $kernelup_en_url -O  $app_dir/$en
fi
else
wget -q $kernelup_pl_url -O  $en
fi
}

case $LANG in
   *PL*) 
langpl;
if [ -e $app_dir/$pl ] ; then
source $app_dir/$pl;
else
source $pl;
fi;;
      *) 
langen;
if [ -e $app_dir/$en ] ; then
source $app_dir/$en;
else
source $en;
fi;;
esac

print_text()
{
 for TXT in $( echo $2 | tr -s '[ ]' '[@]' | sed -e 's@[a-x A-X 0-9]@ &@g' )
 do
	echo -e -n "\E[$1;1m$TXT\033[0m" | tr '@' ' '
	sleep 0.06
 done
 echo ""
}

show_text()
{
	echo -e -n "\E[$1;1m$2\033[0m"
 	echo ""
}

check_security()
{
if [[ "$(lsb_release -si)" != "Ubuntu" && "$(lsb_release -si)" != "LinuxMint"  ]] ; then
   show_text 31 "---[$dist_fail]---" 1>&2
   rm -rf $temp_dir;
   exit 1
fi

if [ "$(id -u)" != "0" ]; then
show_text 31 "$root_fail" 1>&2
   rm -rf $temp_dir;
   exit 1
fi
}

test_connect()
{
ping -q -c1 $connect_test_url1 >$temp
if [ "$?" -eq "2" ];
then
ping -q -c1 $connect_test_url2 >$temp
if [ "$?" -eq "2" ];
then
ping -q -c1 $connect_test_url3 >$temp
if [ "$?" -eq "2" ];
then
show_text 31 "$no_connect";
rm -rf $temp;
exit 1;
fi
fi
fi
}

install_plugins()
{
show_text 31 "$install_plugin_answer";
read adres;
wget -q --no-cache $adres -O $plugins_dir/$RANDOM.kernelup;

if [ $? -eq 0 ]
    then
echo -e -n '';
else
show_text 31 "$install_plugin_error";
fi 
chmod 777 $plugins_dir/*.kernelup;
if [ $? -eq 0 ]
    then
show_text 32 "$install_plugin_ok";
else
show_text 31 "$install_plugin_error";
fi 
}

remove_old_kernel()
{
show_text 31 "$ask_remove";
read answer;
default_answer;
if [[ $answer == "T" || $answer == "t" || $answer == "y" || $answer == "Y" ]]; then
apt-get remove -y --purge $(dpkg -l 'linux-image-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d');
apt-get remove -y --purge $(dpkg -l 'linux-headers-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d');
apt-get -y autoremove;
apt-get -y autoclean;
apt-get -y clean;
update-grub;
fi
}

procedure_reboot()
{
rm -rf $log_dir/$log_name_reboot;
show_text 31 "$ask_reboot";
read answer;
default_answer;
if [[ $answer == "T" || $answer == "t" || $answer == "y" || $answer == "Y" ]]; then
reboot;
else
touch $log_dir/$log_name_reboot;
fi
}

remove_old_kernel_init()
{
if [ -e $log_dir/$log_name ] ; then
remove_old_kernel;
rm -rf $log_dir/$log_name;
fi
}

reboot_init()
{
if [ -e $log_dir/$log_name_reboot ] ; then
procedure_reboot;
fi
}

remove_app()
{
show_text 31 "$answer_remove";
read answer;
default_answer;
if [[ $answer == "T" || $answer == "t" || $answer == "y" || $answer == "Y" ]]; then
wget -q $remove_url -O $remove_name;
chmod +x $remove_name;
./$remove_name;
exit;
fi
}

copy_error()
{
print_text 31 "$copy_wrong";
wget -q $remove_url -O $remove_name;
chmod +x $remove_name;
./$remove_name;
exit;
}

check_success_copy()
{
if [ $? -eq 0 ]
    then
echo -e -n '';
else
copy_error;
fi
}

copy_file()
{
if [ -e $app_dir/$app_name_male ] ; then
echo -e -n '';
else
show_text 31 "=> $copy_file";
read answer;
default_answer;

if [[ $answer == "T" || $answer == "t" || $answer == "y" || $answer == "Y" ]]; then

if [ -e $autostart_dir ] ; then
echo -e -n '';
else
mkdir -p $autostart_dir
fi

cp $0 $app_dir/$app_name_male
check_success_copy;
cp $app_name_male*.lang $app_dir
check_success_copy;
wget -q $init_url -O $init_name;
check_success_copy;
wget -q $desktop_url -O $desktop_name;
check_success_copy;
wget -q $icon_url -O $icon_name;
check_success_copy;
wget -q $kernelup_run_url -O $kernelup_run_name;
check_success_copy;
chmod +x $init_name;
check_success_copy;
chmod +x $kernelup_run_name;
check_success_copy;
mv $icon_name $icon_path;
check_success_copy;
mv $init_name $app_dir;
check_success_copy;
mv $kernelup_run_name $app_dir;
check_success_copy;
cp $desktop_name $autostart_dir;
check_success_copy;
mv $desktop_name $applications_path;
check_success_copy;
create_app_data;
check_success_copy;
add_chmod;
check_success_copy;

if [ $? -eq 0 ]
    then
print_text 33 "=> $copy_ok";
echo -e "\E[37;1m=> $run\033[0m" "\E[35;1msudo $app_name_male\033[0m";
fi
fi
fi
}

update()
{
wget --no-cache --no-dns-cache -q $version_url -O $url
echo "$version" > $temp3

cat $url|tr . , >$temp
cat $temp3|tr . , >$temp2

sed -i 's@,@@g' $temp
sed -i 's@,@@g' $temp2

ver7=`cat "$temp"`
ver9=`cat "$temp2"`

if [ $ver7 -eq $ver9 ]
    then
print_text 35 "=> $new_version"
else
print_text 37 "=> $download_new"

wget -q $kernelup_up -O $up

chmod +x "$up"

rm -rf $temp
rm -rf $temp2
rm -rf $temp3
rm -rf $url
./"$up"
exit
fi
}

notyfication()
{
    if [ -f "/usr/bin/notify-send" ]; then
notify-send "$app_name" "$found $you_kernel $latest_kernel_installed \n $new_version_kernel $latest_kernel_available\n $found1" -i $icon_path/$icon_name;
    elif [ -f "/usr/bin/kdialog" ];then
kdialog --title="$app_name" --msgbox="$found $you_kernel $latest_kernel_installed \n $new_version_kernel $latest_kernel_available\n $found1";
    elif [ -f "/usr/bin/zenity" ];then
zenity --info --title="$app_name" --text="$found $you_kernel $latest_kernel_installed \n $new_version_kernel $latest_kernel_available\n $found1";
    fi
}

reboot_notyfication()
{
 if [ -f "/usr/bin/notify-send" ]; then
notify-send "$app_name" "$reboot_now_com" -i $icon_path/$icon_name;
    elif [ -f "/usr/bin/kdialog" ];then
kdialog --title="$app_name" --msgbox="$reboot_now_com";
    elif [ -f "/usr/bin/zenity" ];then
zenity --info --title="$app_name" --text="$reboot_now_com";
    fi
}

check_kernel_update()
{
mkdir -p $temp_dir;
cd $temp_dir;

print_text 33 "=> $check_kernel";

wget -q $ubuntu_url -O $temp3;
sed -i 's@<a href="@ http://kernelup/@g' $temp3;
sed -i 's@/">@ @g' $temp3;
sed -i 's@[[:space:]]@\n@g' $temp3;
sed -i '/^[ \t]*$/ d' $temp3;
grep 'http://kernelup/v' $temp3 >$temp1;
sed -i 's@http://kernelup/@@g' $temp1;

latest_kernel_version=$(cat $temp1 | grep -v rc | tail -n 1);
latest_kernel_available=$(echo $latest_kernel_version | cut -d "/" -f 6 | cut -d "-" -f1 | tr -d v );
if [ -z $(echo $latest_kernel_available | cut -d "." -f3) ] ; then latest_kernel_available=${latest_kernel_available}.0; fi

if [ $latest_kernel_installed = $latest_kernel_available ] ; then

print_text 32 "=> $kernel_update";

else

mkdir -p $kat;

wget -q $ubuntu_url/$latest_kernel_version -O $temp4;

sed -i "s@lowlatency@~@g" $temp4;
cat $temp4 | cut -d~ -f2-100 >$temp2;
sed -i 's@<a href="linux@~~~linux@g' $temp2;
sed -i 's@.deb">@.deb @g' $temp2;
sed -i 's@<td>@ @g' $temp2;
sed -i 's@[[:space:]]@\n@g' $temp2;
grep '~~~linux' $temp2 >$temp4;
sed -i 's@~~~@@g' $temp4;
sed -i "s@^@$ubuntu_url/$latest_kernel_version/@g" $temp4;
sed -i "s@http://@<program1>http://@g" $temp4;
sed -i "s@_amd64.deb@_amd64.deb</program1>@g" $temp4;
sed -i "s@_i386.deb@_i386.deb</program2>@g" $temp4;
sed -i "s@_all.deb@_all.deb</program3>@g" $temp4;
awk -vRS="</program1>" '{gsub(/.*<program1.*>/,"");print}' $temp4 > $x64;
sed -i "s@<program1>@<program2>@g" $temp4;
awk -vRS="</program2>" '{gsub(/.*<program2.*>/,"");print}' $temp4 > $x86;
sed -i "s@<program2>@<program3>@g" $temp4;
awk -vRS="</program3>" '{gsub(/.*<program3.*>/,"");print}' $temp4 > $xall;

if [ -e $log_dir/$log_name_reboot ] ; then
reboot_notyfication;
else
notyfication;
fi

print_text 33 "=> $you_kernel $latest_kernel_installed"
print_text 35 "=> $new_version_kernel $latest_kernel_available"
check_security;

arch2=`uname -m`

if  [ $arch2 = i686 ] || [ $arch2 = i386 ] || [ $arch2 = x86 ]; then

print_text 31 "$install_new_kernel"

read answer;
default_answer;

if [[ $answer == "N" || $answer == "n" ]]; then
data_clear
else
print_text 32 "$install_kernel_version $latest_kernel_available $for_architecture x86";
refresh_system;

for LINK in $(cat $x86); do
wget -q "$LINK" -O kernel$NR.deb
NR=$[NR + 1]
done;

for LINK in $(cat $xall); do
wget -q "$LINK" -O kernel$NR.deb
NR=$[NR + 1]
done;

mv *.deb $kat

cd $kat

dpkg -i *.deb

if [ $? -eq 0 ]
    then
print_text 35 "=> $instalation_close"
touch $log_dir/$log_name;
procedure_reboot;
else
print_text 31 "$instalation_error"
fi

cd ..

rm -rf $kat

fi

elif [ $arch2 = "x86_64" ]; then
print_text 31 "$install_new_kernel"

read answer;
default_answer;

if [[ $answer == "N" || $answer == "n" ]]; then
data_clear
else
print_text 32 "$install_kernel_version $latest_kernel_available $for_architecture x86_64";
refresh_system;

for LINK in $(cat $x64); do
wget -q "$LINK" -O kernel$NR.deb
NR=$[NR + 1]
done;

for LINK in $(cat $xall); do
wget -q "$LINK" -O kernel$NR.deb
NR=$[NR + 1]
done;

mv *.deb $kat

cd $kat

dpkg -i *.deb

if [ $? -eq 0 ]
    then
print_text 35 "=> $instalation_close"
touch $log_dir/$log_name;
procedure_reboot;
else
print_text 31 "$instalation_error"
fi

cd ..

rm -rf $kat

fi

else
print_text 31 "=> $unsup_arch"
fi

fi
cd $actual_dir
rm -rf $temp_dir
}

while [ "$1" ] ; do 
case "$1" in
  "--help"|"-h") 
   echo -e "$app_name_styl"
   echo "-h, --help:  $help";
   echo "-v, --version: $ver_info";
   echo "-u, --update: $update_info";
   echo "-k, --kernel_update: $kernel_search";
   echo "-r, --remove: $kernelup_remove";  
   echo "-R, --rkernel: $delete_old_kernel";
   echo "-c, --copy: $copy_info";
   echo "-a, --author: $author_info"; 
   echo "-pi, --plugin-installer: $plugin_info"; 
exit ;;
   "--version"|"-v") 
   echo -e "$app_name_styl"
   echo "$version_info $version"; 
exit ;;
   "--update"|"-u")
   check_security;
   test_connect;
   echo -e "$app_name_styl"
   update; 
exit;;
   "--kernel_update"|"-k")
   echo -e "$app_name_styl";
   test_connect;
   check_kernel_update;
exit;;
"--remove"|"-r")
   check_security;
   test_connect;
   remove_app;
exit;;
"--plugin-installer"|"-pi")
   test_connect;
   install_plugins;
exit;;
"--rkernel"|"-R")
   check_security;
   remove_old_kernel;
exit;;
 "--copy"|"-c")
   check_security;
   test_connect;
   rm -rf "$app_dir/$app_name_male*";
   copy_file -y; 
exit;;
 "--systemreboot"|"-sr")
    check_security;
    procedure_reboot;
exit;;
 "--author"|"-a")
   echo -e "$app_name_styl"
   echo -e "$name_author";
exit;;
*)    
      echo -e "$error_unknown_option_text"
      exit 1;
      ;;
    esac
done

clear;
check_security;
echo -e "$app_name_styl"
test_connect;
update;
copy_file;
remove_old_kernel_init;
reboot_init;
load_plugins;
check_kernel_update;
data_clear;
echo -e "$name_author";
