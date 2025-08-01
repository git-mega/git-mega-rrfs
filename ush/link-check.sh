#!/bin/bash
#  check whether all links in the working copy point to a valid mega file under the mega space
#
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $basedir/libfuncs.sh
SetDirs
exit_if_not_mega

mypath="$1"
if [[ ! -e "$mypath" ]]; then
  echo "Usage: git mega link-check  <dir>" >&2
  exit 1
fi

# find links pointing to an inaccessible mega file
echo "inaccessible mega files:"
find "$mypath" -type l -print0 | while IFS= read -r -d '' myfile
do
  if [[ ! "$myfile" == *".git/"* ]] && [[ ! "$myfile" == *".mega/"* ]] && $(is_link_to_mega_space "$myfile"); then
    flink=$(readlink $myfile)
    fhash=${flink##*/}
    fname=$qroot/${fhash:0:2}/${fhash}
    if [[ ! -e $fname ]]; then
      #if dir existed but mega file not accessible, it means current MIRROR lacks this file as well
      echo -e "${myfile}:\n  ${fhash:0:2}/${fhash}"
    fi
  fi
done
