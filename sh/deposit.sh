#!/bin/bash
#
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $basedir/libfuncs.sh
SetDirs
exit_if_not_mega

chmod_w_dirs

mypath="$1"
if [[ -e "$mypath" ]]; then
  echo "Searching for large or non-text files ...."
  find "$mypath" -type f -print0 | while IFS= read -r -d '' myfile
  do
    ignore_output=$(git check-ignore $myfile 2>/dev/null)
    if [[ ! "$myfile" == *".git"* ]] && [[ ! "$myfile" == *".mega/"* ]] && [[ "$ignore_output" == ""  ]]; then
      deposit_if_mega_file "$myfile" >/dev/null
    fi
  done
  echo -e "\nDone"
else
  echo "Usage: git mega depoist <.|dir|file>"
  exit
fi
