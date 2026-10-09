#!/usr/bin/gawk -E
function rewind(    i)
{
    # shift remaining arguments up
    for (i = ARGC; i > ARGIND; i--)
        ARGV[i] = ARGV[i-1]

    # make sure gawk knows to keep going
    ARGC++

    # make current file next to get done
    ARGV[ARGIND+1] = FILENAME

    # do it
    nextfile
}

/Dirty:|Writeback:/ {
  printf("%-10s %'d kb\n", $1, $2)
  # system("sleep 2")
  # rewind()
}


