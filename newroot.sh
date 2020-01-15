#!/bin/bash
 
#Now we in the changed root

#Host name
host=dips42

#User
user=dips

#Timezone
timezone=Asia/Krasnoyarsk

#Windows partition
winpart=/dev/sda1

#Root of instalation media. May be ./ , if used some dirrectory for debugging this scripts.
root=/

#Colored message
function print_message(){
echo -e "\e[36m$1\e[0m"
}

#Setup timezone
print_message "Make link to timezone"
ln -sf ${root}usr/share/zoneinfo/$timezone ${root}etc/localtime
cal

print_message "Setup hardware clock"
hwclock --systohc
cat ${root}etc/adjtime

#Setup locale
print_message "Setup locale"
sed -i 's/#en_US\.UTF-8/en_US.UTF-8/' ${root}etc/locale.gen
sed -i 's/#ru_RU\.UTF-8/ru_RU.UTF-8/' ${root}etc/locale.gen
locale-gen
echo "LANG=ru_RU.UTF-8" > ${root}etc/locale.conf
{
echo "KEYMAP=ru" 
echo "FONT=cyr-sun16"
} > ${root}etc/vconsole.conf

#Setup hosts
print_message "Setup hosts"
echo ${host} > ${root}etc/hostname
{
echo "127.0.0.1 localhost" 
echo "::1 localhost"
echo "127.0.1.1 ${host}.localadmin ${host}"
} > ${root}etc/hosts

#Tune pacman
print_message "Tune pacman"
sed -i s/#Color/Color/ ${root}etc/pacman.conf
sed -i s/#TotalDownload/TotalDownload/ ${root}etc/pacman.conf

pswd=
#print_message "Enter password for User root:"
read -p "Enter Password for User 'root': " pswd
echo -e "${pswd}\n${pswd}\n" | passwd

useradd -m -g users -G wheel -s /bin/bash ${user}
#print_message "Enter password for User ${user}:"
read -p "Enter Password for User '${user}': " pswd
echo -e "${pswd}\n${pswd}\n" | passwd ${user}

#Mount Windows for GRUB autodetect
if (( ${#winpart}>0 )); then
print_message "Mount Windows"
mkdir /mnt/win
mount -t ntfs ${winpart} /mnt/win
fi

#Install GRUB
print_message "Install GRUB"
pacman -S grub os-prober
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
umount ${winpart}

#Install Internet packages
print_message "Install Internet packages"
pacman -S sudo nano dhcpcd netctl wpa_supplicant dialog crda broadcom-wl iw iwd wireless_tools ipw2200-fw wireless-regdb

#Setup sudoers
print_message "Setup sudoers"
sed -i 's/^#\+\s*\(%wheel\s\+ALL=(ALL)\s\+ALL\)/\1/' /etc/sudoers

print_message "Now you can reboot system and install X's by your hands)))"
