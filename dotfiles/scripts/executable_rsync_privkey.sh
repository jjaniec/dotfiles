#!/bin/bash
KEY=$1

rsync -Pav -e "ssh -i $1" $@
