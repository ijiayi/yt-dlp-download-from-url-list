

# yt-dlp Download from URL List

A Bash script that downloads videos from a list of URLs using yt-dlp with customizable options and output paths.

## Features

- **Batch Downloads**: Process multiple URLs from a text file
- **Custom Output Paths**: Specify different output directories for each URL
- **Proxy Support**: Built-in SOCKS5 proxy support
- **Concurrent Downloads**: Control download speed and concurrency
- **Error Handling**: Configurable error handling and retry options
- **Download Archive**: Prevents re-downloading already processed videos
- **Playlist Support**: Download specific items from playlists

## Usage

```bash
./dl-url.sh [OPTIONS]
```

### Options

| Option | Description | Example |
|--------|-------------|---------|
| `-p` | Enable SOCKS5 proxy (127.0.0.1:1080) | `./dl-url.sh -p` |
| `-f <file>` | Specify input file (default: url.txt) | `./dl-url.sh -f my-urls.txt` |
| `-i <items>` | Download specific playlist items | `./dl-url.sh -i "1-5,10"` |
| `-a` | Enable abort on error | `./dl-url.sh -a` |
| `-c` | Continue on task errors | `./dl-url.sh -c` |
| `-g` | Ignore all errors | `./dl-url.sh -g` |
| `-n <num>` | Set concurrent fragments | `./dl-url.sh -n 8` |
| `-r <rate>` | Limit download rate | `./dl-url.sh -r 1M` |

### URL File Format

Create a text file (default: `url.txt`) with URLs and optional output paths:

```
# Comments start with #
# Format: <url> [<output_path>]
https://www.youtube.com/watch?v=example1 Videos/Music
https://www.youtube.com/watch?v=example2
https://www.youtube.com/playlist?list=example3 Playlists/Educational
```

- **URL only**: Downloads to current directory
- **URL + path**: Downloads to specified subdirectory
- **Comments**: Lines starting with `#` are ignored

## Examples

### Basic Usage
```bash
# Download from default url.txt file
./dl-url.sh

# Use custom URL file
./dl-url.sh -f my-downloads.txt
```

### Advanced Usage
```bash
# Download with proxy and custom rate limit
./dl-url.sh -p -r 500K

# Download specific playlist items with error tolerance
./dl-url.sh -i "1-10" -g

# High-speed download with abort on error
./dl-url.sh -n 16 -a
```

## Requirements

- **yt-dlp**: Install via `pip install yt-dlp` or package manager
- **Bash**: Compatible with Bash shell environments

## Output Format

- **File naming**: `%(title).200B.%(ext)s` (title truncated to 200 bytes)
- **Preferred formats**: MP4 video, M4A audio
- **Archive file**: `./archive.txt` tracks downloaded videos

## Error Handling

The script provides multiple levels of error handling:

1. **Default**: Continues downloading other URLs after errors
2. **`-a` flag**: Stops on first error (abort on error)
3. **`-c` flag**: Ignores task-level errors completely
4. **`-g` flag**: Ignores all yt-dlp errors

## Files

- `dl-url.sh` - Main download script
- `url.txt` - Default URL list file (rename or copy from `url.sample.txt`)
- `archive.txt` - Download history (auto-generated)

## Reference

* [yt-dlp Documentation](https://github.com/yt-dlp/yt-dlp)
* [Linux/UNIX: Bash Read a File Line By Line](https://www.cyberciti.biz/faq/unix-howto-read-line-by-line-from-file/)