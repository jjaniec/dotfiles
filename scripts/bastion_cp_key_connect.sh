#!/bin/bash
# Copy private key to a bastion host and connect to it

# Usage: bastion_cp_key_connect.sh ~/Downloads/DefaultKPIreland.pem ec2-user@54.229.226.23

$DOTFILES_DIR/scripts/rsync_privkey.sh "$@"':key.pem'
host_str=$(echo $_ | cut -d ':' -f 1)
ssh -i $1 ${host_str}
