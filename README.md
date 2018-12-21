# Music Management

A set of tools and configurations I use for managing my digital collection of music

## add-replay-gain.sh

A Bash script for batch-computing and writing ReplayGain tags. Only FLAC files are supported currently.

```
Usage: add-replay-gain.sh [-f] directory

Recursively walks over the specified directory and its
subdirectories and adds ReplayGain tags to FLACs in every
folder. If all files in a given folder are already tagged,
the folder is skipped (unless -f is specified).

  -f    Force recalculation and overwrite existing tags
  -h    Show this message and exit
```

## auto-white-balance.sh / auto-white-balance.scm

Performs GIMPs automatic white balance operation in batch mode. I found this to generally have a positive effect on the brightness and contrast of artwork scans.

```
Usage: auto-white-balance.sh directory

Uses GIMP batch mode to peform an automatic white balance
operation (which effectively is an RGB level stretch) on all
TIF image files in the specified directory. Files are
modified in place.

This script relies on the presence of the accompanying SCM
script in the user's GIMP scripts folder. If it hasn't been
installed yet, the script offers to link it.

  -h    Show this message and exit
```

## generate-covers.sh

A Bash script for batch-converting artwork TIFs to cover JPGs per folder. I use TIFs for archiving scans but they are unsuitable for displaying cover art in media players. For one thing, at 300 DPI they are way bigger than needed. For another, most media players assume covers to be stored in e.g. `cover.jpg` which doesn't match my artwork naming pattern.

```
Usage: generate-covers.sh [-f] directory

Recursively walks over the specified directory and its
subdirectories and creates cover.jpg files from artwork TIFs.
Only the first matching TIF in each folder is used. If a
cover JPG already exists in a given folder, the folder is
skipped (unless -f is specified).

  -f    Force regeneration and overwrite existing JPGs
  -h    Show this message and exit
```
