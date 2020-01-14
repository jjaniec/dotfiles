#!/bin/bash
#d Decides how to handle fzf previews

#u FZF_DEFAULT_OPTS="--preview \"fzf_preview.sh {}\""

filetype=$(file ${1})

if echo ${filetype} | grep "ASCII text";
then
	bat --color=always --plain ${1} 2>/dev/null || cat ${1}
elif echo ${filetype} | grep "directory";
then
	ls -lAG ${1}
elif echo ${filetype} | grep "executable";
then
  nm ${1}
else
  echo ${filetype}
  xxd ${1}
fi;
