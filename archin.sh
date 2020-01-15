#!/bin/bash

#Setup Internet. Something like wifi-menu or dhcpcd enp0s3.
#Make filesystem partitions. Mounting will be done in this script.
#Something like: 
#	fdisk /dev/sda; mkfs.ext4 /dev/sda4; 
#	mkswap /dev/sda3; swapon /dev/sda3; 

#Target partition. Where ArchLimux is to be installed.
target=/dev/sda1

#Mount point
mountpoint=/mnt
mount $target $mountpoint

#Country of mirrorlist
country=Russia

#Path of mirrorlist
mirrorlist=${root}etc/pacman.d/mirrorlist

#Root of instalation media. May be ./ , if used some dirrectory for debugging this scripts.
root=/

#Temporary files
out=${root}tmp/.___arch_get_mirrow___

#Colored message
function print_message(){
echo -e "\e[36m$1\e[0m"
}

#Enable NTP servers.
timedatectl set-ntp true

#Setup timezone.
timedatectl set-timezone Asia/Krasnoyarsk
print_message "Current date is:"
date
timedatectl status
hwclock

print_message "Move up your country in mirrorlist for best ranged downloading."
#Find country URL's
sed -r -n "/^#+ *${country}/,+1p" $mirrorlist > ${out}
#Delete #-prefixed country
sed -r "s/^#+ *${country}//" ${out} > ${out}2
#Delete # from begin of server string
sed -r "s/^#+ *//" ${out}2 > ${out}3
#Check size of ranged mirrorlist. If normal - replace original.
outsize=$(wc -c <"${out}3")
if [ ${outsize} -ge 10 ]; then
    echo "$FILE exist"
    cp ${out}3 $mirrorlist
fi
rm ${out}
rm ${out}2
rm ${out}3

print_message "Download base system and linux kernel"
pacstrap $mountpoint base linux linux-firmware

cp /newroot.sh $mountpoint
print_message "Now you must run ./newroot.sh in the new filesystem."
print_message "Change root to new filesystem"
arch-chroot $mountpoint
