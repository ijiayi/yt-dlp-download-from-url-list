#!/bin/bash

input_filename="url.txt"
proxy=""

while getopts ":pf:" opt; do
    case $opt in
        p)
            proxy="--proxy socks5://127.0.0.1:1080"
            ;;
        f)
            filename="$OPTARG"
            if [[ -n "$filename" && -f "$filename" ]]; then
                input_filename="$filename"
            else
                echo "Error: File '$filename' does not exist."
                exit 1
            fi
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

if [[ -z $proxy ]]; then
    echo Info: proxy off
else
    echo Info: proxy on: $proxy
fi

echo Info: input filename: $input_filename

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

done < "$input_filename"
