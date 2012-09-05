#!/bin/sh
rm -rf ~/ntfs_temp/*
export work_dir=~/work
echo "work dir --> " & pwd $work_dir
echo "grep $target_dir to find bad symlink files ......"
grep -rnH --binary-files=text "\!<symlink>" $target_dir | grep --binary-files=text ":1:\!<symlink>" | strings > 01.temp_x

#----------------- debug
#cat 01.temp_x | grep "\!<symlink>$" > 01.temp_y_ng
#cat 01.temp_x | grep "\!<symlink>..*$" > 01.temp_y_ok
#cat 01.temp_y_ok | sed -e "s/\(.*\):1:\!/echo \"\1\"; /g" > 01.temp_y
#cat 01.temp_y | sed -e "s/<symlink>/grep --binary-files=text \"\\\!<symlink>\" /g" > 01.temp_y
#cd $target_dir
#sh $work_dir/01.temp_y > $work_dir/01.temp_z
#cd $work_dir
#-----------------

#echo "grep /etc to find bad symlink files ......"
#grep -rnH --binary-files=text "\!<symlink>" /etc | grep --binary-files=text ":1:\!<symlink>" | strings | sed -e "s/:1:\!<symlink>.*$//g" | strings > 01.symlink_files.txt

#echo "grep /usr to find bad symlink files ......"
#grep -rnH --binary-files=text "\!<symlink>" /usr | grep --binary-files=text ":1:\!<symlink>" | strings | sed -e "s/:1:\!<symlink>.*$//g" | strings > 01.symlink_files.txt

#echo "grep /bin to find bad symlink files ......"
#grep -rnH --binary-files=text "\!<symlink>" /bin | grep --binary-files=text ":1:\!<symlink>" | strings | sed -e "s/:1:\!<symlink>.*$//g" | strings > 01.symlink_files.txt

cat 01.temp_x | sed -e "s/:1:\!<symlink>.*$//g" > 01.symlink_files.txt

# create copy symlink shell file
cat 01.symlink_files.txt | sed "s/^/cp -v -p --parents /g"  | sed "s/$/ ~\/ntfs_temp/g" > 02.copy_symlink_files.sh

# create change attribute shell file
cat 01.symlink_files.txt | sed "s/^/attrib \+S \"c:\\\Program Files\\\temp/g" | sed "s/$/\"/g" > 03.renew_symlink_files.sh

echo "executing 02.copy_symlink_files.sh ......"
sh 02.copy_symlink_files.sh

# backup files
tar -czvf back.tar.gz ~/ntfs_temp/*

echo "executing 03.renew_symlink_files.sh ......"
sh 03.renew_symlink_files.sh

#echo "update symlink files ......"
#cd ~/ntfs_temp/
#cp -p --preserve -f * /