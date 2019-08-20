#!/bin/bash
#d Urldecode parameters

#u Usage: urldecode.sh [urlencoded]

urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

for i in $@;
do
  urldecode $i;
done;
