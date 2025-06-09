#!/bin/bash
# git mega help
help_n_exit()
{
  mysection=$1
  echo "Usage:"
  if [[ "$mysection" == "all" ]] || [[ "$mysection" == "first" ]]; then
  cat <<EOF
  qit mega [help]
  git mega status/hello
  git mega install
  git mega deposit/withdraw <dir|file>
  git mega gethash file
  git mega ls-files <dir|file>
  git mega compareDirs src dest
  git mega verify <dir>
  git mega repair <dir>
  git mega link-check <dir>
  git mega collision-check

 1.show help information
 2.check whether git-mega is installed and/or the disk size of the mega space
 3.install git-mega for current clone
 4.deposit mega files to, or withdraw from the mega space,<dir> takes a relative path
 5.generate the file hash used by git-mega for a given file
 6.list all mega file under a given directory/file
 7.compare the mega files in two directories and show those in src but not in dest
 8.verify the integrity of mega files in the mega space
 9.repair broken links, <dir> takes a relative path
 10.check whether mega-file links in given directory are valid and accessible
 11.check duplicate hashes to make sure no SHA512SUM collisions

EOF
  fi

  if [[ "$mysection" == "gge" ]]; then
  cat <<EOF
  git mega uninstall

EOF
  fi

  exit 0
}
