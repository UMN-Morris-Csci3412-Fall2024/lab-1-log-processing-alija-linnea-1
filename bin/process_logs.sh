# Create a temporary scratch directory
scratch_dir=$(mktemp -d)

source=$(pwd)

#iterate over all the tar archives and extract them
for tar_archive in "$@"; do
    tar -xzf "$tar_archive" -C "$scratch_dir"
done

cd $scratch_dir

#iterate over all newly created directorys and call process_client_logs
for dir in */ ; do
    source "${source}/bin/process_client_logs.sh" $dir
done

cd "${source}"

source "${source}/bin/create_username_dist.sh" $scratch_dir

cd "${source}"

source "${source}/bin/create_hours_dist.sh" $scratch_dir

cd "${source}"

source "${source}/bin/create_country_dist.sh" $scratch_dir

cd "${source}"

source "${source}/bin/assemble_report.sh" $scratch_dir

mv "${scratch_dir}/failed_login_summary.html" "${source}/failed_login_summary.html"