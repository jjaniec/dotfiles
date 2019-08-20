#!/bin/bash
#d Copy private key to a bastion host and connect to it

#u Usage: bastion_cp_key_connect.sh ~/Downloads/DefaultKPIreland.pem ec2-user@ip

echo AWS_CURRENT_BASTION_KEYFILE=$1 > $PWD/.autoenv.zsh
echo AWS_CURRENT_BASTION_USER="$(echo $2 | cut -d '@' -f 1)" >> $PWD/.autoenv.zsh
echo AWS_CURRENT_BASTION_IP="$(echo $2 | cut -d '@' -f 2)" >> $PWD/.autoenv.zsh

$DOTFILES_DIR/scripts/rsync_privkey.sh "$@"':key.pem'
host_str=$(echo $_ | cut -d ':' -f 1)
ssh -o StrictHostKeyChecking=no -i $1 ${host_str}
