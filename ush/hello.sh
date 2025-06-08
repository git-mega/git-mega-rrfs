#!/bin/bash
#
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $basedir/libfuncs.sh
SetDirs

exit_if_not_mega

echo "Hello, git-mega is installed"
chmod_w_dirs
