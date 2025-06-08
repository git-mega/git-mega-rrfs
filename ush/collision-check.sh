#!/bin/bash
#
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $basedir/libfuncs.sh
SetDirs
exit_if_not_mega

chmod_w_dirs

mypath="$1"
if [[ -e "$mypath" ]]; then
  find "$mypath" -type f -print0 | while IFS= read -r -d '' myfile
  do
    ignore_output=$(git check-ignore $myfile 2>/dev/null)
    if [[ ! "$myfile" == *".git"* ]] && [[ ! "$myfile" == *".mega/"* ]] && [[ "$ignore_output" == ""  ]]; then
      if $(MegaOrNot "$myfile") ; then
        myhash=$( ${MEGA_SHA_CMD} "$myfile" | cut -d ' ' -f1)
        if [ -z "$myhash" ]; then
          echo "cannot generate SHA512SUM for '$file'" 1>&2
        else
          subdir=${myhash:0:2}
          destfile="$qroot"/"$subdir"/"$myhash"
          if [[ -s $destfile  ]]; then
            echo "$myfile: $myhash exists"
          fi
        fi
      fi
    fi
  done

  echo -e "\nIf some hashes already exist in the current MEGA space, do as follows to check whether there is a potentential collision:"
  echo "  git mega ls-files . > tmp.txt  # this may take a few minutes"
  echo "  grep myhash tmp.txt   # find the existing files with the given myhash"
  echo "diff the existing file with the to-be-committed file"
  echo "Note: SHA512SUM is NOT expected to have hash collisions at least in the next 100 years"
  echo "So if two files get the same hash, they are expeted to be the same file"
  echo "Report if it is otherwise and it will be breaking news, :)"

else
  echo "Usage: git mega collision-check  <.|dir|file>" >&2
  exit 1
fi
