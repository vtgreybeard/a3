#!/bin/bash

# Check if a numeric argument is provided
if [ $# -ne 1 ] || ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Usage: $0 <numeric_argument>"
    exit 1
fi

archive_name="/tmp/$1.tar"

# Create a temporary directory for staging
temp_dir=$(mktemp -d)

add_folder() {
    source_path="$1"
    dest_path="$2"
    mkdir -p "$temp_dir$dest_path"
    cp -R "$source_path"* "$temp_dir$dest_path"
}

add_folder "appliance/" "/usr/local/sbin/"
add_folder "webui/" "/home/alike/Alike/docroot/"
add_folder "hooks/" "/home/alike/Alike/hooks/"
add_folder "binaries/java/" "/home/alike/Alike/java/"

# These won't be part of the regular updates
#cp "binaries/blkfs" "$temp_dir/usr/local/sbin/"
#cp "binaries/abd.munger" "$temp_dir/usr/local/sbin/"
#cp "binaries/abd.dat.7z" "$temp_dir/usr/local/sbin/"
#cp "binaries/xapi-xe_1.249.3-2_amd64.deb" "$temp_dir/usr/local/sbin/xapi.deb"

tar -cf "$archive_name" -C "$temp_dir" .
7z a "$archive_name".7z $archive_name
rm $archive_name


rm -rf "$temp_dir"

echo "Archive $archive_name created successfully."

