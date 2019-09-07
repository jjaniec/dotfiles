#!/bin/bash
#d List scripts with descriptions & usages

#u Usage: list_scripts.sh

set -o nounset
set -o errexit
# set -o xtrace

get_desc() {
  r=$(
    grep '^#d' ${1} | \
      cut -d ' ' -f 2-
  )
  echo $r
}

get_usage() {
  r=$(
    grep '^#u' ${1} | \
      cut -d ' ' -f 2-
  )
  if echo ${r} | cut -d ' ' -f 1 | grep -i 'usage' > /dev/null 2>&1;
  then
    r=$(echo $r | cut -d ' ' -f 2-)
  fi;
  echo $r
}

find_longest_element() {
  r=0
  for i in $@
  do
    str=$(echo ${i} | rev | cut -d '/' -f 1 | rev)
    if [ ${#str} -gt ${r} ];
    then
      r=${#str}
    fi;
  done;
  echo $r
}

for i in $DOTFILES_DIR/scripts/*;
do
  if [ ${i} = ${0} ];
  then
    continue;
  fi;
  desc=$(get_desc ${i})
  usage=$(get_usage ${i})
  longest_string=$(find_longest_element $DOTFILES_DIR/scripts/*)
  printf "%${longest_string}s\t%s\t\n%${longest_string}s\t%s\n" "$(echo ${i} | rev | cut -d '/' -f 1 | rev)" "${desc}" '' "${usage}"
  #echo -e "$(echo ${i} | rev | cut -d '/' -f 1 | rev)\t${desc}\t${usage}"
done;
