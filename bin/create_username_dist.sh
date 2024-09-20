#!/bin/bash

#get directory path of directory with all the directorys in it
directory="$1"

home=$(pwd)

cd $directory # ......../data

usernames_file="usernames.txt"

usernames_file_path="${usernames_file}" # .........../data/data/usernames.txt

touch "${usernames_file}"

for dir in */ ; do
    # if [ ! -f "${dir}/failed_login_data.txt" ] ; then
    #     echo "$0: ${dir}/failed_login_data.txt does not exist."
    #     exit 1
    # fi

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

awk '{print"data.addRow([\x27"$2"\x27, "$1"]);"}' "$sorted_usernames_file" > $contents_file

    # if [ ! -f "${home}/bin/wrap_contents.sh" ] ; then
    #     echo "$0: ${home}/bin/wrap_contents.sh does not exist."
    #     exit 1
    # fi

source ${home}/bin/wrap_contents.sh $contents_file "username_dist" "username_dist.html"