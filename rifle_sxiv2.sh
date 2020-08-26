#!/bin/sh

# rifle_sxiv2.sh
# Author : Austin Burt
# Email  : austin@burt.us.com
# Date   : 08/26/20

# Using the custom commands.py file ranger will print a file containing a
# number representing the line the cursor is on, and the filenames in the order
# ranger is currently displaying them.  This allows the user to sort files
# in any order like mtime, or random, and sxiv will match that sort order and
# display the current image.

# This is supposed to be called in rangers rifle.conf as a workaround for the
# fact that sxiv takes no file name arguments for the first image, just the
# number.  Copy this file somewhere into your $PATH.
# Then add this at the top of rifle.conf: 
#   mime ^image, has sxiv, X, flag f = path/to/this/script -- "$@"

# remove "--" if present
[ "$1" = "--" ] && shift

# If there is more than one selected file then we want to show those files.
if [ $# -gt 1 ]
then
    #set selected_files so it doesn't start with a '\n'
    selected_files="$1" && shift
    until [ -z "$1" ]; do
        selected_files="$selected_files\n$1"
        shift
    done
    echo $selected_files | sxiv -as f -
    exit 0
fi

# No (or 1) slected files, so use sorted file.
# The data file ranger will create
sorted_files_path="$HOME/.local/share/ranger/copy_sorted_files"

# grab the first line, containing a number of which index the cursor is on
cursor_index=$(sed 1q "$sorted_files_path")

# The line number of the image in the file
file_index="$((cursor_index+1))"

# The actual filename the given number corresponds to.
cursor_filename=$(sed -n "$file_index p" "$sorted_files_path")

#a file was selected, don't display everything, just the selected file.
[ ! "$1" = "$cursor_filename" ] && sxiv -as f "$1" \
    && exit 0

# No file is selected, show all.
# All lines but the first are filenames, display them in sxiv, showing the
# image the cursor is on, auto play gifs, start in fullscreen
sed -n -e '2,$p' "$sorted_files_path" | sxiv -n $cursor_index -as f -

exit 0
