#!/bin/bash

contents_file="$1"
specifier="$2"
result_file="$3"

home=$(pwd)

# cd $temp_dir

#find local file path to the contents_file that will be put in the middle

# if [ ! -f "${contents_file}" ] ; then
#     echo "$0: ${contents_file} not found."
#     exit 1
# fi

contents_file_path=$(find . -name $contents_file)

header_file="${specifier}_header.html"
footer_file="${specifier}_footer.html"

#find local file path to the header file that will be put on top
# if [ ! -f "../html_components/${header_file}" ] ; then
#     echo "$0: ${header_file} not found."
#     exit 1
# fi

# if [ ! -f "../html_components/${footer_file}" ] ; then
#     echo "$0: ${footer_file} not found."
#     exit 1
# fi

specifier_header_path=$(find ../html_components -name $header_file)

#find local file path to the footer file that will be put on the bottom
specifier_footer_path=$(find ../html_components -name $footer_file)

#get string contents of all needed files

middle=$(< $contents_file_path)

# echo $middle
# exit 1

top=$(< $specifier_header_path)

bottom=$(< $specifier_footer_path)

contents="${top}
${middle}
${bottom}"

#create html file and add the contents to it
cat > $result_file << EOF

$contents

EOF

