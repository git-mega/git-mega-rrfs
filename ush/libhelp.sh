#!/bin/bash
# git mega help
help_n_exit()
{
  mysection=$1
  echo "Usage:"
  if [[ "$mysection" == "all" ]] || [[ "$mysection" == "first" ]]; then
  cat <<EOF
  qit mega [help]
  git mega hello
  git mega install
  git mega deposit/withdraw <dir|file>
  git mega gethash file
  git mega compareDirs src dest
  git mega verify <dir>
  git mega repair <dir>
  git mega allHandsCheck

 1.show help information
 2.check whether git-mega is installed
 3.install git-mega for current clone
 4.deposit mega files to, or withdraw from the mega space,<dir> takes a relative path
 5.generate the file hash used by git-mega for a given file
 6.compare the mega files in two directories and show those in src but not in dest
 7.verify the integrity of mega files in the mega space
 8.repair broken links, <dir> takes a relative path
 9.check whether all mega-file links in the working directory are valid

EOF
  fi

  if [[ "$mysection" == "gge" ]]; then
  cat <<EOF
  git mega uninstall

EOF
  fi

  exit 0
}
