# ranger-sxiv-compatibility

This repo is something I put together in order to have ranger, and sxiv work as
I feel they should work. In larger directories sxiv would open only the image
the cursor was on, not the directory. Then it would break ranger, with a glitch
that made it as though there were two cursors, and which one of the two was the
users cursor would alternate per key press. On top of fixing this ranger
breaking bug, I wanted them to open on the image my cursor was on, and keep the
order displayed by ranger, with any filtering taken into account as well.

Together these achieve that goal.  The commands.py, creates a command for
ranger to print the order of the current files and the rifle_sxiv2.sh is called
by the rifle.conf to read that file, or to show the selected files.

## Inspiration

At this point the two scripts are very different, but I came across
[rifle_sxiv.sh](https://github.com/ranger/ranger/blob/master/examples/rifle_sxiv.sh)
in the official ranger repo. A simple POSIX compliant script that used the Unix
find command as its main driver. but it didn't solve my problem either. It did
fix some of the issues sxiv was having with large directories causing bugs in
ranger, but the sort order was entirely defined by how the find command works.

The afore mentioned script is obviously where my script got it's name. Normally
I use bash for scripts, but this made a point to use a POSIX compliant solution
so I did the same with mine and used a `sh` script. If it isn't compliant for
some reason than it's because I don't know what all breaks POSIX compliance.  I
also tried to document fully what the script is doing.

# How to use/Installation

These 2 files are almost everything, but some manual work is required for all
the moving parts to line up correctly.  If you have come across this problem
yourself and are looking for the fix, then I'm assuming you are at least
moderately capable in the terminal.  These aren't programs people typically use
on day 1.

The commands.py should be copied to your user config directory for ranger. Mine
is at `~/.config/ranger/commands.py`

OR

If you already have a commands.py with custom commands, add the command to your
file.

Then, in your rc.conf add:

`map l chain save_sorted_files_buffer; move right=1`

This allows normal browsing with `h,j,k,l`.  But every time you hit `l`, ranger
will create the in-order list. So selecting a picture with `l` creates the
file, and next, the sh script will read it.

I did a similar map to `<C-l>` chaining it in with redraw_window, in case I
need a different way to make the list.

Next, copy the rifle_sxiv2.sh to a directory in your `$PATH` and make it
executable. I put mine in `~/bin`

Then in rifle.conf find the header `# Image Viewing:` add this line below the
header, as the first (default) image viewer.

`mime ^image, has sxiv,      X, flag f = ~/bin/rifle_sxiv2.sh -- "$@"`

Ensuring you use the path where you put the script earlier.

And that's it!  If you don't have any of the config files I mentioned look at
the man pages for ranger on how to get the default ones.

# Known Bugs

Using `Enter` to select the images will use an old sorted file and cause some
wonkiness, unless you remap it like the `C-l` map shown earlier. A minor issue
that doesn't bother me as I almost always us `l` for selection.

If you have one file selected, and the cursor is on that same line when you hit
`l` all images will be shown like if there was no selected image.

Note: I do not use python hardly ever, so I think I have way too many imports I
don't feel like sorting out and maybe other inefficiencies so any
suggestions/pull requests to make this the best it can be is appreciated.  On
the same idea, if POSIX compliance is not met and you know why and how to
improve it please share.
