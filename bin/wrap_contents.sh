#!/bin/bash

# Check if the correct number of arguments are provided
if [ $# -ne 3 ]; then
  echo "Usage: $0 <contents_file> <specifier> <result_file>"
  exit 1
fi

contents_file="$1"
specifier="$2"
result_file="$3"

# Define paths for header and footer based on the specifier
header_file="html_components/${specifier}_header.html"
footer_file="html_components/${specifier}_footer.html"

# Check if the necessary files exist
if [ ! -f "$contents_file" ]; then
  echo "Error: Contents file $contents_file not found."
  exit 1
fi

if [ ! -f "$header_file" ]; then
  echo "Error: Header file $header_file not found."
  exit 1
fi

if [ ! -f "$footer_file" ]; then
  echo "Error: Footer file $footer_file not found."
  exit 1
fi

# Combine the header, contents, and footer into the result file
cat "$header_file" > "$result_file"
cat "$contents_file" >> "$result_file"
cat "$footer_file" >> "$result_file"

echo "Successfully generated $result_file"
