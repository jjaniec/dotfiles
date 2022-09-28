#!/bin/bash
#d Decides how to handle fzf previews

#u FZF_DEFAULT_OPTS="--preview \"fzf_preview.sh {}\""

filetype=$(file ${1})

PAGER=cat

if command -v bat > /dev/null 2>&1;
then
  PAGER=bat
fi

if echo ${filetype} | grep "ASCII text";
then
  ${PAGER} ${1} 2>/dev/null
elif [ -d ${1} ];
then
	ls -lAG --color ${1}
elif echo ${filetype} | grep "executable";
then
  nm ${1}
else
  echo ${filetype}
  xxd ${1}
fi;
