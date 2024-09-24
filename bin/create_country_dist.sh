#!/bin/bash

#get directory path of directory with all the directorys in it
directory="$1"

home=$(pwd)

cd "$directory" || exit 1

ips_file="ips.txt"

ips_file_path="${ips_file}"

touch "${ips_file}"

for dir in */ ; do
    # if [ ! -f "${dir}/failed_login_data.txt" ] ; then
    #     echo "$0: ${dir}/failed_login_data.txt does not exist."
    #     exit 1
    # fi

    temp=$(awk '{print $5}' "${dir}/failed_login_data.txt")
    for word in $temp; do
    echo "$word" >> $ips_file_path
    done
done

sorted_ip_file="sorted-ip.txt"

rm -f "$sorted_ip_file"

sort $ips_file > "$sorted_ip_file"

country_ip_map="${home}/etc/country_IP_map.txt"

sorted_country_file="sorted_countries.txt"

touch "$sorted_country_file"

join "$sorted_ip_file" "$country_ip_map" | awk '{print $2}' | sort > "$sorted_country_file"

contents_file="country_contents.txt"

touch "$contents_file"

uniq -c "$sorted_country_file" | awk '{print"data.addRow([\x27"$2"\x27, "$1"]);"}' > "$contents_file"


source "${home}/bin/wrap_contents.sh" $contents_file "country_dist" "country_dist.html"