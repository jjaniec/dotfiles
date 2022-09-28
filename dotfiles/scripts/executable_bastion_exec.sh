#!/bin/bash
#d Execute command on current bastion set by $AWS_CURRENT_BASTION_IP,
#d or just ssh if no commands are specified in arguments

#u Usage: bastion_exec.sh [command]

source $PWD/.autoenv.zsh || true

ssh -i $AWS_CURRENT_BASTION_KEYFILE "$AWS_CURRENT_BASTION_USER"@"$AWS_CURRENT_BASTION_IP" $@
