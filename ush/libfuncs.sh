#!/bin/bash
# colloections of commom functions
# all non "local" variables are global and can be acessed by calling scripts
#
MEGA_SHA_CMD=${MEGA_SHA_CMD:-"shasum -a 512"}
MEGA_SHASTR_LEN="128"

#find the workTreeTop, tmpdir, qroot
function SetDirs {
  workTreeTop=$( git rev-parse --show-toplevel 2>/dev/null )
  tmpdir=$workTreeTop/.git/mega_tmp
  qroot=$workTreeTop/.mega
  mainTreeTop=$workTreeTop
}

# chmod -R +w for all read-only directories under current worktree
#  GIT should not deal with read-only files/directories, otherwise
#  it will cause unexpected messy results when swithing between commits
chmod_w_dirs()
{
  for mydir in $(find $workTreeTop -type d -not -path '*/.git/*' -not -path '*/.mega/*' -ls|grep 'dr-x'|rev|cut -d ' ' -f1|rev|xargs); do
    chmod -R +w $mydir
  done
}

exit_if_not_mega()
{
  if [[ ! -s $workTreeTop/.mega.conf ]] ; then
    echo "git-mega is NOT installed, run 'git mega install' to install"
    exit 1
  fi
}

# determine whether a string is a possible SHA512SUM
isSHA512SUM()
{
  local STR="$1"
  if [[ "$STR"  =~ ^[a-f0-9]+$ ]] && [[ ${#STR} -eq $MEGA_SHASTR_LEN ]]; then
    echo true
  else
    echo false
  fi
}

# Is $1 a link pointing to a mega file
is_link_to_mega_space()
{
  local mylink=$1
  if [[ -L $mylink ]]; then #only determin if it is a link, don't need it to be a valid link
    local lnfile=$(readlink $mylink ) 
    if [[ "${lnfile}" == *".mega/"* ]]; then
      lnfile=${lnfile##*/}
      if $(isSHA512SUM "$lnfile"); then
        echo true
      else
        echo false
      fi
    else
      echo false
    fi
  else
    echo false
  fi
}

# determine whether a file($1) should be put into the mega space
function MegaOrNot {
  local filepath="$1"
  [ -d $filepath ] && return false  #return 1 if it is a directory
  [ -L $filepath ] && return false  #return 1 if it is a link

  mega_it=$(isMegaFile ${workTreeTop}/.mega.conf $filepath)

  if $mega_it; then
    filesize=$(stat -c %s $filepath)
    local sizestring=$(numfmt --to=iec $filesize 2>/dev/null)
    echo "git-mega:process '$filepath',${sizestring}" 1>&2
#  else
#    echo "git-mega:no action '$filepath'" 1>&2  #avoid unnessary messages
  fi
  echo $mega_it
}

# deposit a mega file into the mega space and lock it
deposit_if_mega_file()
{
  local myfile="$1"
  local collision=false
  if $(MegaOrNot "$myfile") ; then
    local myhash=$( ${MEGA_SHA_CMD} "$myfile" | cut -d ' ' -f1)
    if [ -z "$myhash" ]; then
      echo 'false'
      echo "cannot generate SHA512SUM for '$file'" 1>&2
    else
      local subdir=${myhash:0:2}
      local destfile="$qroot"/"$subdir"/"$myhash"
      mkdir -p "$qroot"/"$subdir" 2>/dev/null
      if [[ -s "$destfile"  ]]; then # make sure no hash collision
        if ! diff -q $myfile $destfile &> /dev/null; then
          echo -e "FATAL: SHA512SUM collision found:\n$myfile\n$subdir/$myhash" 1>&2
          collision=true
#       else
#         echo -e "DEBUG: no difference" 1>&2
        fi
      fi
      if $collision; then
        echo 'false'
      else # no collision, which is expected in the next 100 years or so
        chmod +w "$destfile" 2>/dev/null
        mv -f "$myfile" "$destfile" 2>/dev/null #always trust new checksum-verified file
        chmod a-w "$destfile" #lock the mega file
        ln -rsnf "$destfile" "$myfile"
        echo 'true'
      fi
    fi
  else
    echo 'false'
  fi
}

source $basedir/libhelp.sh

