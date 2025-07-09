
#!/bin/bash

set -euo pipefail

# Default values
input_filename="url.txt"
proxy=""
ignore_task_error=0

# yt-dlp common arguments
comm_arg_array=(
    -N 4
    --download-archive ./archive.txt
    -S ext:mp4:m4a
    -o "%(title).200B.%(ext)s"
    --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
)

# Parse options
while getopts ":pgacn:f:i:r:" opt; do
    case $opt in
        p)
            proxy="--proxy socks5://127.0.0.1:1080"
            comm_arg_array+=(--proxy socks5://127.0.0.1:1080)
            ;;
        f)
            filename="$OPTARG"
            if [[ -n "$filename" && -f "$filename" ]]; then
                input_filename="$filename"
            else
                echo "Error: File '$filename' does not exist." >&2
                exit 1
            fi
            ;;
        i)
            playlist_item="$OPTARG"
            comm_arg_array+=(--playlist-items "$playlist_item")
            ;;
        a)
            comm_arg_array+=(--abort-on-error)
            ;;
        c)
            ignore_task_error=1
            ;;
        g)
            comm_arg_array+=(--ignore-errors)
            ;;
        n)
            concurrent="$OPTARG"
            comm_arg_array+=(--concurrent-fragments "$concurrent")
            ;;
        r)
            limit_rate="$OPTARG"
            comm_arg_array+=(--limit-rate "$limit_rate")
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

if [[ -z $proxy ]]; then
    echo "Info: proxy off"
else
    echo "Info: proxy on: $proxy"
fi

echo "Info: input filename: $input_filename"
echo "Info: comm_arg: ${comm_arg_array[*]}"

# Read url and output path from input file
while IFS=' ' read -r url out_path || [[ -n "$url" ]]; do
    # Skip empty lines and comments
    [[ -z "$url" || "$url" =~ ^# ]] && continue

    # Set output path, default to current directory if not specified
    out_dir="./${out_path:-}"
    echo "Info: yt-dlp ${comm_arg_array[*]} $url -P '$out_dir'"
    if ! yt-dlp "${comm_arg_array[@]}" "$url" -P "$out_dir"; then
        if [[ $ignore_task_error -ne 1 ]]; then
            echo "Error: Command failed for URL: $url, Output path: $out_dir" >&2
            exit 1
        fi
    fi
done < "$input_filename"
