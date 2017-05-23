#!/bin/bash

# set
SSH_USER=""
if [ "${DOCKER_SSH_USER}" ]
then
    SSH_USER="${DOCKER_SSH_USER}"
else
    SSH_USER="`head -n 4096 /dev/urandom | tr -cd '[:alnum:]' | head -c 8`"
fi
SSH_PASSWORD=""
if [ "${DOCKER_SSH_PASSWORD}" ]
then
    SSH_PASSWORD="${DOCKER_SSH_PASSWORD}"
else
    SSH_PASSWORD="`head -n 4096 /dev/urandom | tr -cd '[:alnum:]!@#$%^&*_' | head -c 16`"
fi
SSH_SECURE_CHPWD_DISABLED=""
if [ "${DOCKER_SSH_SECURE_CHPWD_DISABLED}" = "true" ]
then
    SSH_SECURE_CHPWD_DISABLED=true
else
    SSH_SECURE_CHPWD_DISABLED=false
fi
SSH_SECURE_CHPWD_PERIOD=""
if [ "${DOCKER_SSH_SECURE_CHPWD_PERIOD}" ]
then
    SSH_SECURE_CHPWD_PERIOD=`expr ${DOCKER_SSH_SECURE_CHPWD_PERIOD} \* 1`
else
    SSH_SECURE_CHPWD_PERIOD=30
fi

# useradd sudo password
useradd -g users ${SSH_USER}
echo '
'${SSH_USER}' ALL=(ALL) ALL' \
>> /etc/sudoers
echo -e "$SSH_PASSWORD\n$SSH_PASSWORD" | (passwd --stdin ${SSH_USER} > /dev/null 2>&1)

# supervisor
sed -i 's#nodaemon=false#nodaemon=true#' /etc/supervisord.conf
sed -i 's#\[unix_http_server\]#;\[unix_http_server\]#' /etc/supervisord.conf
sed -i 's#file=/tmp/supervisor.sock#;file=/tmp/supervisor.sock#' /etc/supervisord.conf
sed -i 's#\[rpcinterface:supervisor\]#;\[rpcinterface:supervisor\]#' /etc/supervisord.conf
sed -i 's#supervisor.rpcinterface_f#;supervisor.rpcinterface_f#' /etc/supervisord.conf
sed -i 's#\[supervisorctl\]#;\[supervisorctl\]#' /etc/supervisord.conf
sed -i 's#serverurl=unix:///tmp/superv#;serverurl=unix:///tmp/superv#' /etc/supervisord.conf
echo '
[eventlistener:supervisor_stdout]
command=/usr/bin/supervisor_stdout
events=PROCESS_LOG
result_handler=supervisor_stdout:event_handler

[program:sshd]
command=/usr/sbin/sshd -D
redirect_stderr=true
stdout_events_enabled=true' \
>> /etc/supervisord.conf

# chpwd
sed -i "s#SSH_USER=\${SSH_USER}#SSH_USER=${SSH_USER}#" /chpwd.sh
sed -i "s#RUN_SLEEP=\${RUN_SLEEP}#RUN_SLEEP=${SSH_SECURE_CHPWD_PERIOD}#" /chpwd.sh
if [ "${SSH_SECURE_CHPWD_DISABLED}" = "false" ]
then
    echo '
[program:chpwd]
command=/bin/sh /chpwd.sh
redirect_stderr=true
stdout_events_enabled=true' \
>> /etc/supervisord.conf
fi

# output
echo "----- ----- ----- ----- -----"
echo "----- ----- ----- ----- -----"
echo "----- ----- ----- ----- -----"
if [ "${DOCKER_SSH_USER}" ]
then
    echo "ssh user: *** (created by env)"
else
    echo "ssh user: ${SSH_USER}"
fi
if [ "${DOCKER_SSH_PASSWORD}" ]
then
    echo "ssh user password: *** (created by env)"
else
    echo "ssh user password: ${SSH_PASSWORD}"
fi
if [ "${DOCKER_SSH_SECURE_CHPWD_DISABLED}" ]
then
    echo "ssh secure password change every ${SSH_SECURE_CHPWD_PERIOD} minutes [disabled]"
else
    echo "ssh secure password change every ${SSH_SECURE_CHPWD_PERIOD} minutes [enabled]"
fi
echo "----- ----- ----- ----- -----"
echo "----- ----- ----- ----- -----"
echo "----- ----- ----- ----- -----"

# run
#/usr/sbin/sshd -D
/usr/bin/supervisord
