#!/bin/bash

#get directory path of directory with all the directorys in it
directory="$1"

home=$(pwd)

echo "hours home ${home}"

cd "$directory" || exit 1

hours_file="hours.txt"

hours_file_path="${hours_file}" 

touch "${hours_file}"

for dir in */ ; do
    # if [ ! -f "${dir}/failed_login_data.txt" ] ; then
    #     echo "$0: ${dir}/failed_login_data.txt does not exist."
    #     exit 1
    # fi

    temp=$(awk '{print $3}' "${dir}/failed_login_data.txt")
    for word in $temp; do
    echo "$word" >> $hours_file_path
    done
done

sorted_hours_file="sorted-hours.txt"

rm -f "$sorted_hours_file"

sort $hours_file | uniq -c > "$sorted_hours_file"

contents_file="hours_contents.txt"

rm -f "$contents_file"

touch "$contents_file"

awk '{print"data.addRow([\x27"$2"\x27, "$1"]);"}' "$sorted_hours_file" > "$contents_file"

    # if [ ! -f "${home}/bin/wrap_contents.sh" ] ; then
    #     echo "$0: ${home}/bin/wrap_contents.sh does not exist."
    #     exit 1
    # fi

source "${home}/bin/wrap_contents.sh" "$contents_file" "hours_dist" "hours_dist.html" "$home"