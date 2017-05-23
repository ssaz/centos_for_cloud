#!/bin/bash

RUN_SLEEP=${RUN_SLEEP}
SSH_USER=${SSH_USER}

sleep `expr ${RUN_SLEEP} \* 60`

SSH_PASSWORD="`head -n 4096 /dev/urandom | tr -cd '[:alnum:]!@#$%^&*_' | cut -c1-16`"
echo ""
echo "----- ----- ----- ----- -----"
echo "----- ----- ----- ----- -----"
echo "----- ----- ----- ----- -----"
echo "ssh user new password: ${SSH_PASSWORD}"
echo "----- ----- ----- ----- -----"
echo "----- ----- ----- ----- -----"
echo "----- ----- ----- ----- -----"
echo -e "${SSH_USER}:${SSH_PASSWORD}" | chpasswd

exit 255
