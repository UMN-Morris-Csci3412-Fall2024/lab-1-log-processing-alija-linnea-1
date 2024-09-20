
# Create a temporary scratch directory
scratch_dir=$(mktemp -d)


#iterate over all the tar archives and extract them
for tar_archive in "$@"; do
    tar -xzf "$tar_archive" -C "$scratch_dir"
done

cd $scratch_dir

#iterate over all newly created directorys and call process_client_logs
for dir in */ ; do
    source process_client_logs.sh $dir
done