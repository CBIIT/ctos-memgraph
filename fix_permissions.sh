#!/bin/bash

USERNAME=$1
OLD_UID=$2
NEW_UID=$3
GROUPNAME=$4
OLD_GID=$5
NEW_GID=$6

usermod -u $NEW_UID $USERNAME
groupmod -g $NEW_GID $GROUPNAME

PATHS_TO_CHECK=("/home" "/var/lib" "/var/log" "/etc")
for i in ${PATHS_TO_CHECK[@]}; do
	echo "Checking $i"
	find $i -group $OLD_GID -exec chgrp -h $GROUPNAME {} \;
	find $i -user $OLD_UID -exec chown -h $USERNAME {} \;
done

