#!/bin/bash

# Check if the correct number of arguments are passed
if [ $# -ne 1 ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

input_directory=$1
output_file="$input_directory/country_dist.html"
temp_file=$(mktemp)

# Debugging: Print directory being processed
echo "Processing directory: $input_directory"

# Ensure the provided directory exists
if [ ! -d "$input_directory" ]; then
  echo "Error: Directory $input_directory does not exist."
  exit 1
fi

# Extract IP addresses from all failed_login_data.txt files in the subdirectories
for client_dir in "$input_directory"/*/; do
  if [ -f "$client_dir/failed_login_data.txt" ]; then
    echo "Extracting IPs from: $client_dir/failed_login_data.txt"
    awk '{print $4}' "$client_dir/failed_login_data.txt" >> "$temp_file"
  else
    echo "No failed_login_data.txt in $client_dir"
  fi
done

# If no IPs were extracted, exit
if [ ! -s "$temp_file" ]; then
  echo "No failed login data found."
  rm "$temp_file"
  exit 0
fi

# Debugging: Print extracted IP addresses
echo "Extracted IPs:"
cat "$temp_file"

# Sort and join IPs with country mappings from etc/country_IP_map.txt
sort "$temp_file" | join -o 2.2 -1 1 -2 1 - <(sort etc/country_IP_map.txt) > "$temp_file".countries

# Debugging: Print the country codes
echo "Mapped countries:"
cat "$temp_file".countries

# Count occurrences of each country
sort "$temp_file".countries | uniq -c | awk '{print "data.addRow([\x27"$2"\x27, "$1"]);"}' > "$temp_file".rows
cat "$temp_file".rows  # Add this line to print the rows

# Debugging: Check rows generated for the chart
echo "Generated rows for GeoChart:"
cat "$temp_file".rows

# Wrap the results with the header and footer to create the full HTML file
echo "Generating HTML file at: $output_file"
bin/wrap_contents.sh "$temp_file".rows country_dist "$output_file"

# Check if the HTML file was created
if [ -f "$output_file" ]; then
  echo "HTML file $output_file successfully generated."
else
  echo "Error: Failed to generate HTML file."
fi

# Clean up temporary files
rm "$temp_file" "$temp_file".countries "$temp_file".rows
