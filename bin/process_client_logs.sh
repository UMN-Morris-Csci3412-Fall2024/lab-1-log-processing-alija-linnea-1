#!/bin/bash
export LC_ALL=C.UTF-8

# Check if the directory argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Change to the specified directory
cd "$1" || { echo "Failed to change directory to $1"; exit 1; }

# Initialize or clear the output file
: > failed_login_data.txt

# Extract all .tgz files
for file in *.tgz; do
    echo "Extracting $file..."
    tar -zxvf "$file"
done

# Debugging output to ensure we are reading files
echo "Processing log files in directory: $PWD"
ls -1

# **Modified: Recursively find the log files and process them**
# Find all "secure" files recursively and process them
find . -type f -name "secure*" | while read -r log_file; do
    echo "Processing $log_file..."
    
    # Filter out non-ASCII characters and extract failed login attempts
    cat "$log_file" | tr -cd '\11\12\15\40-\176' | awk '
    BEGIN { print "Started processing logs..." > "/dev/stderr" }

    # Ignore empty lines
    NF > 0 {
      # Handle invalid user login attempts
      if ($0 ~ /Failed password for invalid user/) {
        split($3, time, ":"); # Split the time to get just the hour
        print $1, $2, time[1], $9, $11 >> "failed_login_data.txt";
      }

      # Handle valid user login attempts
      else if ($0 ~ /Failed password for/ && $0 !~ /invalid user/) {
        split($3, time, ":"); # Split the time to get just the hour
        print $1, $2, time[1], $9, $11 >> "failed_login_data.txt";
      }
    }
    '
done

# Clean up extracted log files
echo "Cleaning up..."
find . -type f -name "*.log" -delete

# Final debugging output
if [ -s failed_login_data.txt ]; then
  echo "Failed login data successfully written to failed_login_data.txt"
else
  echo "Failed login data not found, file remains empty."
fi
