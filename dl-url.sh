#!/bin/bash

input="url.txt"

if [ "$1" == "proxy" ]; then
    proxy="--proxy socks5://127.0.0.1:1080"
    echo Info: Proxy ON $proxy
else
    proxy=""
    echo Info: Proxy OFF
fi

comm_arg_array=("-N 4" "$proxy" "--abort-on-error" "--download-archive ./archive.txt" "-S ext:mp4:m4a" "-o %(title).200B.%(ext)s")
comm_arg="${comm_arg_array[*]}"
echo Info: comm_arg: $comm_arg

while IFS=\  read -r url out_path 
do
    if [ -n "$url" ] && [[ $url != "#"* ]]; then
        echo Info: yt-dlp $comm_arg "$url" -P "./$out_path"
        yt-dlp $comm_arg "$url" -P "./$out_path"

        exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            echo "Error: Command failed with exit code $exit_code" >&2
            echo "URL: $url"
            echo "Output path: $out_path"
            exit 1
        fi
    fi

done < "$input"
