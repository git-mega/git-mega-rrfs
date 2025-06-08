#!/bin/bash
# install and configure git-mega
#  .mega needs to be outside of .git so that the removal of .git does not affect the .mega storage 
#
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $basedir/libfuncs.sh
SetDirs
if ! $(git rev-parse --is-inside-work-tree &>/dev/null); then
  echo "fatal: not a git repository "
  exit 1
fi

mkdir -p $qroot
mkdir -p $tmpdir

#1. add .mega in .git/info/exclude if not there yet
ierr=`grep "^.mega" $mainTreeTop/.git/info/exclude 1>/dev/null 2>/dev/null; echo $?`
if [[ $ierr -ne 0 ]]; then
  echo -e "\n#ignore the .mega space. DO NOT REMOVE!\n.mega\n" >> $mainTreeTop/.git/info/exclude
fi

#2. generate .mega.conf if not existed
if [[ ! -s  $workTreeTop/.mega.conf ]]; then

cat > $workTreeTop/.mega.conf <<EOF
# track any non "ASCII text" files by git-mega
# file_size>XXXk: track text files if size>XXXk
# !path_from_git_root_to_dest: exclude this file from git-mega
#
#file_size>500k
#!testdata/large_file.txt
EOF

fi

echo -e "git-mega installed for current HEAD.\n
run 'git mega' for more information"
