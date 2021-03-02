#!/bin/bash

if [ $# -ne 2 ] || [[ "$2" != "trainval" && "$2" != "test" ]]
then
	echo "usage: $0 [download_dir] [trainval/test]"
	exit 1
fi

download_baseurl="https://s3.amazonaws.com/ava-dataset"
download_dir="$1"
trainvaltest="$2"

list_filename="ava_file_names_${trainvaltest}_v2.1.txt"
filenames=$(cat "$list_filename")

mkdir -p "$download_dir/$trainvaltest"
bash_start_time=$(date +%s.%N)
index=1
num_segments=$(echo "$filenames" | wc -l)

while read line
do
	echo "$index / $num_segments $line"
	download_url="$download_baseurl/$trainvaltest/$line"
	wget "$download_url" -q -O "$download_dir/$trainvaltest/$line" > /dev/null

	bash_end_time=$(date +%s.%N)
	time_diff=$(echo "$bash_end_time - $bash_start_time" | bc)
	average_time=$(echo "$time_diff / ($index)" | bc -l)
	echo "average processing time per segment: $average_time"
	(( index++ ))
done <<< "$filenames"
