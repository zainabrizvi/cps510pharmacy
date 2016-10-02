#!/bin/bash
echo $0: Fetching public/private keys...

# Create the .ssh directory
mkdir -p ${HOME}/.ssh
chmod 700 ${HOME}/.ssh

# Create the public/private key files from the environmental variables.
echo "${HEROKU_PUBLIC_KEY}" > ${HOME}/.ssh/scs_id_rsa.pub
chmod 644 ${HOME}/.ssh/scs_id_rsa.pub

echo "${HEROKU_PRIVATE_KEY}" > ${HOME}/.ssh/scs_id_rsa
chmod 600 ${HOME}/.ssh/scs_id_rsa

echo "${KNOWN_HOSTS}" > ${HOME}/.ssh/known_hosts


SSH_CMD="ssh -f -i ${HOME}/.ssh/scs_id_rsa -N -L 1521:${REMOTE_SQL_HOST}:1521 ${TUNNEL_USER}@${TUNNEL_SITE}"

PID=`pgrep -f "${SSH_CMD}"`
if [ $PID ] ; then
    echo $0: There is already a tunnel running on ${PID}.
else
    echo $0 Launching a new tunnel...
    $SSH_CMD
fi
