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

#Timezone
timezone=Asia/Krasnoyarsk

#Root of instalation media. May be ./ , if used some dirrectory for debugging this scripts.
root=/

#Path of mirrorlist
mirrorlist=${root}etc/pacman.d/mirrorlist

#Temporary files
out=${root}tmp/.___arch_get_mirrow___

#Colored message
function print_message(){
echo -e "\e[36m$1\e[0m"
}

#Enable NTP servers.
timedatectl set-ntp true

#Setup timezone.
timedatectl set-timezone $timezone
print_message "Current date is:"
date
timedatectl status
hwclock

echo $mirrorlist
print_message "Move up your country in mirrorlist for best ranged downloading."
#Find country URL's
sed -r -n "/^#+ *${country}/,+1p" $mirrorlist > ${out}
#Delete # from begin of server string
sed -r "s/^#+ *(Server.*)/\1/" ${out} > ${out}2
#Check size of ranged mirrorlist. If normal - replace original.
outsize=$(wc -c <"${out}2")
if [ ${outsize} -ge 10 ]; then
    echo "${out}2 exist"
	cat $mirrorlist >> ${out}2
    cp -f ${out}2 $mirrorlist
fi
rm ${out}
rm ${out}2

print_message "Download base system and linux kernel"
pacstrap $mountpoint base linux linux-firmware

cp ~/archin/newroot.sh $mountpoint
print_message "Now you must run /newroot.sh in the new filesystem."
print_message "Change root to new filesystem"
arch-chroot $mountpoint
