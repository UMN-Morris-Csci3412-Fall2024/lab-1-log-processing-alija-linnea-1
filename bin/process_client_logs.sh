#get temp directory with log files in it
temp_dir="$1"

cd "$temp_dir"

#BEGIN { print "Started processing logs..." > "/dev/stderr" }

find . -type f -name "secure*" | while read -r log_file; do
    echo "Processing $log_file..."
    
    # Filter out non-ASCII characters and extract failed login attempts
    cat "$log_file" | tr -cd '\11\12\15\40-\176' | awk '
    # Ignore empty lines
    NF > 0 {
      # Handle invalid user login attempts
      if ($0 ~ /Failed password for invalid user/) {
        split($3, time, ":"); # Split the time to get just the hour
        print $1, $2, time[1], $11, $13 >> "failed_login_data.txt";
      }

      # Handle valid user login attempts
      else if ($0 ~ /Failed password for/ && $0 !~ /invalid user/) {
        split($3, time, ":"); # Split the time to get just the hour
        print $1, $2, time[1], $9, $11 >> "failed_login_data.txt" ;
      }
    }
    '
done