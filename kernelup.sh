#!/bin/bash

#Copyright © 2014 Damian Majchrzak (DamiaX)
#Automatic Ubuntu, Debian, elementary OS and Linux Mint kernel updater.
#https://github.com/DamiaX/KernelUP/

version="6.4";
app='kernelup';
version_url="https://raw.githubusercontent.com/DamiaX/kernelup/master/VERSION";
ubuntu_url="http://kernel.ubuntu.com/~kernel-ppa/mainline";
kernelup_run_url="https://raw.githubusercontent.com/DamiaX/KernelUP/master/Core/kernelup-run";
kernelup_pl_url="https://raw.githubusercontent.com/DamiaX/KernelUP/master/Language/kernelup.pl.lang";
kernelup_en_url="https://raw.githubusercontent.com/DamiaX/KernelUP/master/Language/kernelup.en.lang";
kernelup_up="https://raw.githubusercontent.com/DamiaX/kernelup/master/Core/up.sh"
remove_url="https://raw.githubusercontent.com/DamiaX/KernelUP/master/Core/remove.sh";
desktop_url='https://raw.githubusercontent.com/DamiaX/KernelUP/master/Core/kernelup.desktop';
kernelup_run_desktop_url='https://raw.githubusercontent.com/DamiaX/KernelUP/master/Core/kernelup.desktop';
icon_url='https://raw.githubusercontent.com/DamiaX/KernelUP/master/kernelup.png';
init_url='https://raw.githubusercontent.com/DamiaX/KernelUP/master/Core/kernelup-init';
connect_test_url=(google.com facebook.com kernel.org);
temp=(.kernel.temp .kernel1.temp .kernel2.temp .kernel3.temp .kernel4.temp .url.temp .x64.link .86.link .xall.link .install_katalog up.sh);
kernelup_file_name=(kernelup.png kernelup-init kernelup-init.desktop remove.sh kernelup-run kernelup_run.desktop);
kernelup_lang_name=(kernelup.pl.lang kernelup.en.lang);
kernelup_log_name=(kernelup.klog kernelup_reboot.log);
app_dir='/usr/local/sbin';
icon_path='/usr/share/icons/hicolor/128x128/apps';
applications_path='/usr/share/applications/';
actual_dir="$(pwd)";
temp_dir="$HOME/.kernelup_temp_dir";
autostart_dir="$HOME/.config/autostart/";
latest_kernel_installed=$(ls /boot/ | grep img | cut -d "-" -f2 | sort -V | cut -d "." -f1,2,3 | tail -n 1);
log_dir="$HOME/.KernelUP_data";
plugins_dir="$log_dir/Plugins";
plugins_extension="*.kernelup";
plugins_search="kernelup";
arg1="$1";
arg2="$2";
gui_shell=".kernelup_gui_shell.sh";

refresh_system()
{
apt-get update -y -qq;
apt-get upgrade -y -qq;	
}

default_answer()
{
if [ -z $answer ]; then
answer='y';
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

if [ -e $autostart_dir ] ; then
chmod 777 $autostart_dir;
fi
}

create_app_data()
{
if [ ! -e $log_dir ] ; then
mkdir -p $log_dir;
fi

if [ ! -e $plugins_dir ] ; then
mkdir -p $plugins_dir;
fi

if [ ! -e $autostart_dir ] ; then
mkdir -p $autostart_dir;
fi
add_chmod;
}

remove_empty_plugins()
{
for file in $plugins_dir/$plugins_extension
do
        if [[ ! -s $file ]] && [[ -f $file ]] && [[ ! -L $file ]]
        then
                rm $file -f
        fi
done
}

load_plugins()
{
NR=1
if [ -e $plugins_dir ] ; then
remove_empty_plugins;
ls $plugins_dir | grep -q $plugins_search
if [ $? -eq 0 ]
then
for plugins in $plugins_dir/$plugins_extension ; do
grep -h 'function' $plugins_dir/$plugins_extension > ${temp[0]}
sed -i 's@function@@g' ${temp[0]}
sed -i 's@ @@g' ${temp[0]}
ls $plugins_dir/$plugins_extension >${temp[2]}
plugin_name=`cat "${temp[2]}" | sed -n "$NR p"`
function_name=`cat "${temp[0]}" | sed -n "$NR p"`
. $plugin_name
$function_name
NR=$[NR + 1]
done
rm -rf ${temp[0]}
rm -rf ${temp[2]}
fi
else
mkdir -p $log_dir;
mkdir -p $plugins_dir;
fi
}

langpl()
{
if [ -e $app_dir/$app ] ; then
if [ ! -e $app_dir/${kernelup_lang_name[0]} ] ; then
wget -q $kernelup_pl_url -O  $app_dir/${kernelup_lang_name[0]};
fi
else
wget -q $kernelup_pl_url -O  ${kernelup_lang_name[0]};
fi
}

langen()
{
if [ -e $app_dir/$app ] ; then
if [ ! -e $app_dir/${kernelup_lang_name[1]} ] ; then
wget -q $kernelup_en_url -O  $app_dir/${kernelup_lang_name[1]}
fi
else
wget -q $kernelup_en_url -O  ${kernelup_lang_name[1]}
fi
}

lang_init_pl()
{
if [ -e $app_dir/${kernelup_lang_name[0]} ] ; then
source $app_dir/${kernelup_lang_name[0]};
else
source ${kernelup_lang_name[0]};
fi
}

lang_init_en()
{
if [ -e $app_dir/${kernelup_lang_name[1]} ] ; then
source $app_dir/${kernelup_lang_name[1]};
else
source ${kernelup_lang_name[1]};
fi
}

case $LANG in
*PL*) 
langpl;
lang_init_pl;
 ;;
*) 
langen;
lang_init_en;
 ;;
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
if [[ "$(lsb_release -si)" != "Ubuntu" && "$(lsb_release -si)" != "LinuxMint" && "$(lsb_release -si)" != "elementary OS" && "$(lsb_release -si)" != "Debian" ]] ; then
   show_text 31 "---[$dist_fail]---" 1>&2
   exit;
fi

if [ "$(id -u)" != "0" ]; then
   show_text 31 "$root_fail" 1>&2
   exit;
fi
}

zenity_no_connect()
{
zenity --window-icon="$icon_path/${kernelup_file_name[0]}" --error --text="$no_connect" --title="$app_name";		
}

test_connect()
{
ping -q -c1 ${connect_test_url[0]} >${temp[0]}
if [ "$?" -eq "2" ];
then
ping -q -c1 ${connect_test_url[1]} >${temp[0]}
if [ "$?" -eq "2" ];
then
ping -q -c1 ${connect_test_url[2]} >${temp[0]}
if [ "$?" -eq "2" ];
then
if [ "$1" = "0" ]
then
show_text 31 "$no_connect";
rm -rf ${temp[0]};
exit;
else
zenity_no_connect;
rm -rf ${temp[0]};
exit;
fi
fi
fi
fi
}

check_install_plugin()
{
if [ $? != 0 ]
then
show_text 31 "$install_plugin_error";
exit;
fi
}

install_plugins()
{
if [ -z "$arg2" ] ; then
show_text 31 "$install_plugin_answer";
read adres;
wget -q --no-cache $adres -O $plugins_dir/$RANDOM.kernelup;
check_install_plugin;
else
wget -q --no-cache $arg2 -O $plugins_dir/$RANDOM.kernelup;
check_install_plugin;
fi
chmod 777 $plugins_dir/*.kernelup;
if [ $? -eq 0 ]
    then
show_text 32 "$install_plugin_ok";
else
show_text 31 "$install_plugin_error";
fi 
}

remove_old_kernel_procedure()
{
apt-get remove -y --purge $(dpkg -l 'linux-image-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d');
apt-get remove -y --purge $(dpkg -l 'linux-headers-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d');
apt-get -y autoremove;
apt-get -y autoclean;
apt-get -y clean;
update-grub;	
}

remove_old_kernel()
{
show_text 31 "$ask_remove";
read answer;
default_answer;
if [[ $answer == "T" || $answer == "t" || $answer == "y" || $answer == "Y" ]]; then
remove_old_kernel_procedure;
fi
}

remove_old_kernel_zenity()
{
ans=$(zenity --title="$app_name" --window-icon="$icon_path/${kernelup_file_name[0]}" --list  --text "$ask_remove" --radiolist  --column "$chose_text" --column "$option_text" TRUE "$option_yes" FALSE "$option_no");
if [ "$ans" = "$option_yes" ]; then		
remove_old_kernel_procedure;
fi	
}

reboot_notyfication()
{
 if [ -f "/usr/bin/notify-send" ]; then
notify-send "$app_name" "$reboot_now_com" -i $icon_path/${kernelup_file_name[0]};
    elif [ -f "/usr/bin/kdialog" ];then
kdialog --title="$app_name" --msgbox="$reboot_now_com";
    elif [ -f "/usr/bin/zenity" ];then
zenity --info --title="$app_name" --text="$reboot_now_com";
    fi
}

procedure_reboot()
{
if [ -e $log_dir ] ; then
rm -rf $log_dir/${kernelup_log_name[1]};
reboot_notyfication;
show_text 31 "$ask_reboot";
read answer;
default_answer;
if [[ $answer == "T" || $answer == "t" || $answer == "y" || $answer == "Y" ]]; then
reboot;
else
touch $log_dir/${kernelup_log_name[1]};
echo -e "$name_author";
exit;
fi
else
mkdir -p $log_dir;
touch $log_dir/${kernelup_log_name[1]};
exit;
fi
}

remove_old_kernel_init()
{
if [ -e $log_dir ] ; then
if [ -e $log_dir/${kernelup_log_name[0]} ] ; then
if [ "$1" = "0" ]
then
remove_old_kernel;
rm -rf $log_dir/${kernelup_log_name[0]};
else
remove_old_kernel_zenity;
rm -rf $log_dir/${kernelup_log_name[0]};
fi
fi
else
mkdir -p $log_dir;
fi
}

reboot_init()
{
if [ -e $log_dir ] ; then
if [ -e $log_dir/${kernelup_log_name[1]} ] ; then
procedure_reboot;
fi
else
mkdir -p $log_dir;
fi
}

remove_app()
{
show_text 31 "$answer_remove";
read answer;
default_answer;
if [[ $answer == "T" || $answer == "t" || $answer == "y" || $answer == "Y" ]]; then
wget -q $remove_url -O ${kernelup_file_name[3]};
chmod +x ${kernelup_file_name[3]};
./${kernelup_file_name[3]};
exit;
fi
}

install_error()
{
print_text 31 "$install_wrong";
wget -q $remove_url -O ${kernelup_file_name[3]};
chmod +x ${kernelup_file_name[3]};
./${kernelup_file_name[3]};
exit;
}

check_success_install()
{
if [ $? != 0 ]
then
   install_error;
fi
}

install_app()
{
create_app_data;
cp $0 $app_dir/$app_name_male
check_success_install;
cp $app_name_male*.lang $app_dir
check_success_install;
wget -q $init_url -O ${kernelup_file_name[1]};
check_success_install;
wget -q $desktop_url -O ${kernelup_file_name[2]};
check_success_install;
wget -q $kernelup_run_desktop_url -O ${kernelup_file_name[5]}; 
check_success_install;
wget -q $icon_url -O ${kernelup_file_name[0]};
check_success_install;
wget -q $kernelup_run_url -O ${kernelup_file_name[4]};
check_success_install;
chmod +x ${kernelup_file_name[1]};
check_success_install;
chmod +x ${kernelup_file_name[4]};
check_success_install;
mv ${kernelup_file_name[0]} $icon_path;
check_success_install;
mv ${kernelup_file_name[1]} $app_dir;
check_success_install;
mv ${kernelup_file_name[4]} $app_dir;
check_success_install;
mv ${kernelup_file_name[5]} $autostart_dir;
check_success_install;
mv ${kernelup_file_name[2]} $applications_path;
check_success_install;
add_chmod;
check_success_install;

if [ $? -eq 0 ]
    then
print_text 33 "=> $install_ok";
echo -e "\E[37;1m=> $run\033[0m" "\E[35;1msudo $app_name_male\033[0m";
fi
}

install_file()
{
if [ "$1" = "1" ]
then
if [ ! -e $app_dir/$app_name_male ] ; then
show_text 31 "=> $install_file";
read answer;
default_answer;
if [[ $answer == "T" || $answer == "t" || $answer == "y" || $answer == "Y" ]]; then
install_app;
fi
fi
else
install_app;
fi
}

update()
{
wget --no-cache --no-dns-cache -q $version_url -O ${temp[5]}
echo "$version" > ${temp[3]}

cat ${temp[5]}|tr . , >${temp[0]}
cat ${temp[3]}|tr . , >${temp[2]}

sed -i 's@,@@g' ${temp[0]}
sed -i 's@,@@g' ${temp[2]}

ver7=`cat "${temp[0]}"`
ver9=`cat "${temp[2]}"`

if [ $ver7 -eq $ver9 ]
    then
print_text 35 "=> $new_version"
else
print_text 37 "=> $download_new"

wget -q $kernelup_up -O ${temp[10]}

chmod +x "${temp[10]}"

rm -rf ${temp[0]}
rm -rf ${temp[2]}
rm -rf ${temp[3]}
rm -rf ${temp[5]}
./"${temp[10]}"
exit;
fi
}

notyfication()
{
    if [ -f "/usr/bin/notify-send" ]; then
notify-send "$app_name" "$found $you_kernel $latest_kernel_installed\n $new_version_kernel $latest_kernel_available\n $found1" -i $icon_path/${kernelup_file_name[0]};
    elif [ -f "/usr/bin/kdialog" ];then
kdialog --title="$app_name" --msgbox="$found $you_kernel $latest_kernel_installed\n $new_version_kernel $latest_kernel_available\n $found1";
    elif [ -f "/usr/bin/zenity" ];then
zenity --info --title="$app_name" --text="$found $you_kernel $latest_kernel_installed\n $new_version_kernel $latest_kernel_available\n $found1";
    fi
}

zenity_progress()
{
zenity --info --title="$app_name" --window-icon="$icon_path/${kernelup_file_name[0]}" --text="$change";
}

zenity_kernel_update()
{
zenity --info --title="$app_name" --window-icon="$icon_path/${kernelup_file_name[0]}" --text="$kernel_update";	
}

instalation_kernel_error_zenity()
{
rm -rf $temp_dir;
rm -rf ${temp[*]};
zenity --window-icon="$icon_path/${kernelup_file_name[0]}" --error --text="$instalation_error" --title="$app_name";	
}

reboot_zenity_notyfication()
{
quest=$(zenity --title="$app_name" --window-icon="$icon_path/${kernelup_file_name[0]}" --list  --text " $install_ok \n $reboot_system_zenity" --radiolist  --column "$chose_text" --column "$option_text" TRUE "$option_yes" FALSE "$option_no");
if [ "$quest" = "$option_yes" ]; then
rm -rf "$log_dir/${kernelup_log_name[1]}";
rm -rf $temp_dir;
rm -rf ${temp[*]};
reboot;	
fi
rm -rf $temp_dir;
rm -rf ${temp[*]};
}

check_kernel_update()
{
mkdir -p $temp_dir;
cd $temp_dir;

print_text 33 "=> $check_kernel";

wget -q $ubuntu_url -O ${temp[3]};
sed -i 's@<a href="@ http://kernelup/@g' ${temp[3]};
sed -i 's@/">@ @g' ${temp[3]};
sed -i 's@[[:space:]]@\n@g' ${temp[3]};
sed -i '/^[ \t]*$/ d' ${temp[3]};
grep 'http://kernelup/v' ${temp[3]} >${temp[1]};
sed -i 's@http://kernelup/@@g' ${temp[1]};

latest_kernel_version=$(cat ${temp[1]} | grep -v rc | tail -n 1);
latest_kernel_available=$(echo $latest_kernel_version | cut -d "/" -f 6 | cut -d "-" -f1 | tr -d v );
if [ -z $(echo $latest_kernel_available | cut -d "." -f3) ] ; then latest_kernel_available=${latest_kernel_available}.0; fi

if [ $latest_kernel_installed = $latest_kernel_available ] ; then

if [ "$2" = "1" ]
then
print_text 32 "=> $kernel_update";
else
check_security;
zenity_kernel_update;
fi

else

mkdir -p ${temp[9]};

cd ${temp[9]};

wget -q $ubuntu_url/$latest_kernel_version -O ${temp[4]};

sed -i "s@lowlatency@~@g" ${temp[4]};
cat ${temp[4]} | cut -d~ -f2-100 >${temp[2]};
sed -i 's@<a href="linux@~~~linux@g' ${temp[2]};
sed -i 's@.deb">@.deb @g' ${temp[2]};
sed -i 's@<td>@ @g' ${temp[2]};
sed -i 's@[[:space:]]@\n@g' ${temp[2]};
grep '~~~linux' ${temp[2]} >${temp[4]};
sed -i 's@~~~@@g' ${temp[4]};
sed -i "s@^@$ubuntu_url/$latest_kernel_version/@g" ${temp[4]};
sed -i "s@http://@<program1>http://@g" ${temp[4]};
sed -i "s@_amd64.deb@_amd64.deb</program1>@g" ${temp[4]};
sed -i "s@_i386.deb@_i386.deb</program2>@g" ${temp[4]};
sed -i "s@_all.deb@_all.deb</program3>@g" ${temp[4]};
awk -vRS="</program1>" '{gsub(/.*<program1.*>/,"");print}' ${temp[4]} > ${temp[6]};
sed -i "s@<program1>@<program2>@g" ${temp[4]};
awk -vRS="</program2>" '{gsub(/.*<program2.*>/,"");print}' ${temp[4]} > ${temp[7]};
sed -i "s@<program2>@<program3>@g" ${temp[4]};
awk -vRS="</program3>" '{gsub(/.*<program3.*>/,"");print}' ${temp[4]} > ${temp[8]};

if [ "$1" = "1" ]
then
notyfication;
fi

print_text 33 "=> $you_kernel $latest_kernel_installed"
print_text 35 "=> $new_version_kernel $latest_kernel_available"
check_security;

arch2=`uname -m`

if  [ $arch2 = i686 ] || [ $arch2 = i386 ] || [ $arch2 = x86 ]; then

if [ "$2" = "1" ]
then
print_text 31 "$install_new_kernel"

read answer;
default_answer;

if [[ $answer == "N" || $answer == "n" ]]; then
rm -rf ${temp[*]};
rm -rf $temp_dir;
echo -e "$name_author";
exit;
fi

else
ans=$(zenity --title="$app_name" --window-icon="$icon_path/${kernelup_file_name[0]}" --list  --text " $found $you_kernel $latest_kernel_installed \n $new_version_kernel $latest_kernel_available \n $update_kernel_on_gui_text" --radiolist  --column "$chose_text" --column "$option_text" TRUE "$option_yes" FALSE "$option_no");
if [ "$ans" = "$option_no" ]; then		
rm -rf ${temp[*]};
rm -rf $temp_dir;
echo -e "$name_author";
exit;
fi
fi

if [ "$2" = "0" ]
then
zenity_progress;
fi

print_text 32 "$install_kernel_version $latest_kernel_available $for_architecture x86";
refresh_system;

for LINK in $(cat ${temp[7]}); do
wget -q "$LINK" -O kernel$NR.deb
NR=$[NR + 1]
done;

for LINK in $(cat ${temp[8]}); do
wget -q "$LINK" -O kernel$NR.deb
NR=$[NR + 1];
done;

mv *.deb ${temp[9]};

cd ${temp[9]};

dpkg -i *.deb

if [ $? -eq 0 ]
    then
print_text 35 "=> $instalation_close"
touch $log_dir/${kernelup_log_name[0]};
if [ "$2" = "0" ]
then
reboot_zenity_notyfication;
else
procedure_reboot;	
fi
else
	if [ "$2" = "0" ]
then
instalation_kernel_error_zenity;
else
print_text 31 "$instalation_error"
fi
fi

rm -rf ${temp[9]}

elif [ $arch2 = "x86_64" ]; then

if [ "$2" = "1" ]
then
print_text 31 "$install_new_kernel"

read answer;
default_answer;

if [[ $answer == "N" || $answer == "n" ]]; then
rm -rf ${temp[*]};
rm -rf $temp_dir;
echo -e "$name_author";
exit;
fi

else
ans=$(zenity --title="$app_name" --window-icon="$icon_path/${kernelup_file_name[0]}" --list  --text " $found $you_kernel $latest_kernel_installed \n $new_version_kernel $latest_kernel_available \n $update_kernel_on_gui_text" --radiolist  --column "$chose_text" --column "$option_text" TRUE "$option_yes" FALSE "$option_no");
if [ "$ans" = "$option_no" ]; then		
rm -rf ${temp[*]};
rm -rf $temp_dir;
echo -e "$name_author";
exit;
fi
fi

if [ "$2" = "0" ]
then
zenity_progress;
fi

print_text 32 "$install_kernel_version $latest_kernel_available $for_architecture x86_64";
refresh_system;

for LINK in $(cat ${temp[6]}); do
wget -q "$LINK" -O kernel$NR.deb
NR=$[NR + 1]
done;

for LINK in $(cat ${temp[8]}); do
wget -q "$LINK" -O kernel$NR.deb
NR=$[NR + 1]
done;

mv *.deb ${temp[9]}

cd ${temp[9]}

dpkg -i *.deb

if [ $? -eq 0 ]
then	
print_text 35 "=> $instalation_close"
touch $log_dir/${kernelup_log_name[0]};
if [ "$2" = "0" ]
then
reboot_zenity_notyfication;
else
procedure_reboot;
fi

else
	if [ "$2" = "0" ]
then
instalation_kernel_error_zenity;
else
print_text 31 "$instalation_error"
fi
fi

rm -rf ${temp[9]}
else
print_text 31 "=> $unsup_arch"
fi
fi
cd $actual_dir
rm -rf $temp_dir
}

show_zenity_gui()
{
rm -rf "$gui_shell";
(
echo "# $search_old_kernel";
remove_old_kernel_init 1;
echo "20"; sleep 1
echo "# $check_on_connect_text"; 
echo "40"; sleep 1
test_connect 1;
echo "# $check_kernel" ;
echo "80"; sleep 1
check_kernel_update 0 0;
echo "# $end_text" ;
echo "100"; sleep 1
rm -rf ${temp[*]};
) |
zenity --progress \
  --window-icon="$icon_path/${kernelup_file_name[0]}" \
  --title="$app_name" \
  --text="$run_app_gui $app_name"	
}

zenity_gui()
{
zenity --window-icon="$icon_path/${kernelup_file_name[0]}" --entry  --title "$app_name" --text "$root_fail \n$write_password $cancel_button." --cancel-label="$cancel_button" --hide-text | sudo -S "./$gui_shell" && exit

if [ $? != 0 ]
then
    zenity --error \
    --title "$app_name" \
    --text="$wrong_password"
   exit;

fi

show_zenity_gui;
}
	
check_zenity_gui()
{
if [ -f "/usr/bin/zenity" ];then
echo "./beta_kernelup -ksi" > $gui_shell
echo 'rm -rf $0' >> $gui_shell
chmod +x $gui_shell
zenity_gui;
fi	
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
   echo "-i, --install: $install_info";
   echo "-a, --author: $author_info"; 
   echo "-pi, --plugin-installer: $plugin_info"; 
exit;;
   "--version"|"-v") 
   echo -e "$app_name_styl"
   echo "$version_info $version"; 
exit;;
   "--update"|"-u")
   check_security;
   test_connect 0;
   echo -e "$app_name_styl"
   update; 
exit;;
   "--kernel_update"|"-k")
   echo -e "$app_name_styl";
   test_connect 0;
   check_kernel_update 1 1;
   rm -rf ${temp[*]};
exit;;
"--remove"|"-r")
   check_security;
   test_connect 0;
   remove_app;
exit;;
"--plugin-installer"|"-pi")
   test_connect 0;
   install_plugins;
exit;;
"--rkernel"|"-R")
   check_security;
   remove_old_kernel;
exit;;
 "--install"|"-i")
   check_security;
   test_connect 0;
   rm -rf "$app_dir/$app_name_male*";
   install_file 1;
exit;;
 "--systemreboot"|"-sr")
    check_security;
    procedure_reboot;
exit;;
 "--install_update"|"-iu")
    check_security;
    install_file 0;
exit;;
 "--gui"|"-g")
   check_zenity_gui;
exit;;
"--kernel_silent_install"|"-ksi")
   show_zenity_gui;
   rm -rf ${temp[*]};
exit;;   
 "--author"|"-a")
   echo -e "$app_name_styl"
   echo -e "$name_author";
exit;;
*)    
      echo -e "$error_unknown_option_text"
      exit;
      ;;
    esac
done

clear;
check_security;
echo -e "$app_name_styl"
test_connect 0;
update;
install_file 1;
remove_old_kernel_init 0;
reboot_init;
load_plugins;
check_kernel_update 0 1;
rm -rf ${temp[*]};
rm -rf $temp_dir;
echo -e "$name_author";
