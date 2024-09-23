#!/bin/bash

log_directory="data/discovery/var/log"

output_file="data/discovery/failed_login_data.txt"

if [ ! -d "$log_directory" ]; then
  echo "Log directory does not exist: $log_directory"
  exit 1
fi

# Clear the output file first
> "$output_file"

# Process each secure log file
for log_file in "$log_directory"/secure*; do
  echo "Processing $log_file"
  # Make sure to extract the correct column for IP addresses
  grep "Failed password" "$log_file" | awk '{print $(NF-3)}' >> "$output_file"
done

echo "Failed login data consolidated into $output_file"
