#!/bin/bash

#d Trim whitespaces, windows endlines of files passed in parameters
#u ./trim_whitespaces.sh file1 file2 file3 ...

for i in $@;
do
  echo $i;
  sed -i '' -E 's/^[ ]{1,}$//g;s/[ '$'\t'']+$//;s/\r//' $i;
  sed -i '' -e '/./,$!d' -e :a -e '/^\n*$/{$d;N;ba' -e '}' $i;
done;
