#!/bin/bash

#get directory path of directory with all the directorys in it
directory="$1"

home=$(pwd)

cd $directory

usernames_file="usernames.txt"

rm -f "$usernames_file"

touch "$usernames_file"

usernames_file_path="${directory}/${usernames_file}"
echo $usernames_file_path

for dir in */ ; do
    temp=$(awk '{print $4}' "${dir}/failed_login_data.txt")
    for word in $temp; do
    echo $word >> $usernames_file_path
    done
done

sorted_usernames_file="sorted-usernames.txt"

rm -f "$sorted_usernames_file"

sort $usernames_file | uniq -c > "$sorted_usernames_file"

contents_file="contents.txt"

rm -f "$contents_file"

touch "$contents_file"

datarows=$(awk '{printf "data.addRow([\x27"$2"\x27, "$1"]);"}' "$sorted_usernames_file")

#echo $(awk '{print"data.addRow([\x27"$2"\x27, "$1"]);"}' "$sorted_usernames_file") > $contents_file

echo $datarows > $contents_file

# for row in $datarows; do 
#     echo $row >> $contents_file
# done

source /Users/linneagilbertson/Desktop/ComputingSystemsPracticum/lab-1-log-processing-alija-linnea-1/bin/wrap_contents.sh $contents_file "username_dist" "username_dist.html"