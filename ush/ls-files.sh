#!/bin/bash
#
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $basedir/libfuncs.sh
SetDirs
exit_if_not_mega

chmod_w_dirs

mypath="$1"
if [[ -e "$mypath" ]]; then
  find "$mypath" -type l -print0 | while IFS= read -r -d '' myfile
  do
    ignore_output=$(git check-ignore $myfile 2>/dev/null)
    if [[ ! "$myfile" == *".git"* ]] && [[ ! "$myfile" == *".mega/"* ]] && [[ "$ignore_output" == ""  ]]; then
      dest=$(readlink $myfile)
      if [[ "$dest" == */.mega/* ]]; then
        hash=${dest##*mega/*/}
        echo "$myfile=$hash"
      fi
    fi
  done
else
  echo "Usage: git mega ls-files <.|dir|file>" >&2
  exit 1
fi
