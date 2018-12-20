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
