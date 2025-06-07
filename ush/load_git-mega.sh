#!/bin/bash
# Check if the script is sourced 
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then                                       
  echo "Usage: source ${0}"              
  exit 1                                 
fi 

ushdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
basedir=$(dirname $ushdir)

module use $basedir/modulefiles
module load git-mega

