#!/bin/sh
set -e

WORKSPACE=${WORKSPACE:-/workspace}
if [ \("$USER_ID" > 0\) -o \("$GROUP_ID" > 0\) ]
then                  
        ORIGPASSWD=$(cat /etc/passwd | grep theia)
        ORIG_UID=$(echo $ORIGPASSWD | cut -f3 -d:)
        ORIG_GID=$(echo $ORIGPASSWD | cut -f4 -d:)
                                                                                
        if [ \("$USER_ID" != "$ORIG_UID"\) -o \("$GROUP_ID" != "$ORIG_GID"\) ]; then
                sed -i -e "s/:$ORIG_UID:$ORIG_GID:/:$USER_ID:$GROUP_ID:/" /etc/passwd
                sed -i -e "s/theia:x:$ORIG_GID:/theia:x:$GROUP_ID:/" /etc/group          
                ORIG_HOME=$(echo $ORIGPASSWD | cut -f6 -d:)                
                chown -R theia:theia ${ORIG_HOME}
                if test $CHANGE_OWNER -gt 0
                then 
                        chown -R theia:theia $WORKSPACE
                fi
        fi                                                  
fi

su theia -c "/usr/local/bin/node /home/theia/src-gen/backend/main.js $WORKSPACE --hostname=0.0.0.0"