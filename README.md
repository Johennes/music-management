# Music Management

A set of tools and configurations I use for managing my digital collection of music

## add-replay-gain.sh

A Bash script for batch-computing and writing ReplayGain tags. Only FLAC files are supported currently.

```
Usage: add-replay-gain directory

Recursively walks over the specified directory and its
subdirectories and adds ReplayGain tags to FLACs in every
folder. If all files in a given folder are already tagged,
the folder is skipped (unless -f is specified).

  -f    Force recalculation and overwrite existing tags
  -h    Show this message and exit
```

## generate-covers

A Bash script for batch-converting artwork TIFs to cover JPGs per folder. I use TIFs for archiving scans but they are unsuitable for displaying cover art in media players. For one thing, at 300 DPI they are way bigger than needed. For another, most media players assume covers to be stored in e.g. `cover.jpg` which doesn't match my artwork naming pattern.

```
Usage: generate-covers

Recursively walks over the specified directory and its
subdirectories and creates cover.jpg files from artwork TIFs.
Only the first matching TIF in each folder is used. If a
cover JPG already exists in a given folder, the folder is
skipped (unless -f is specified).

  -f    Force regeneration and overwrite existing JPGs
  -h    Show this message and exit
```
