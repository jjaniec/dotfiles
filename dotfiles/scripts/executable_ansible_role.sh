#!/bin/bash
#d Run ansible role by creating a temp playbook file

#u ./ansible_role.sh role -i hosts

TMP_FILE=./ansible_role.sh.tmp.yaml
cat > ${TMP_FILE} <<EOF
---
- hosts: all
  roles:
    - { role: ${1}, tags: "${1}" }
EOF

ansible-playbook ${TMP_FILE} --tags ${@}
rm ${TMP_FILE}
