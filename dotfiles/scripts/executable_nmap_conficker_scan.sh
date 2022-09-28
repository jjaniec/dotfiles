#!/bin/bash
#d Performs an nmap confiker scan against a network range / host (eg: 192.168.1.1/32)

#u ./nmap_conficker_scan.sh [nmap_options] cidr_block

# https://seclists.org/nmap-dev/2009/q1/869

if [ ${#} -eq 0 ];
then
  echo "Usage: ./nmap_conficker_scan.sh [nmap_options] cidr_block"
  exit 1
fi;

nmap \
  -sV \
  -sC \
  -p- \
  -PN \
  -n \
  -T4 \
  --min-parallelism 128 \
  --min-hostgroup 256 \
  ${@}
