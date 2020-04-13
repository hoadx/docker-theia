#!/bin/sh
set -e

WORKSPACE=${WORKSPACE:-/workspace}
CHANGE_OWNER=${CHANGE_OWNER:-0}

if [ "$USERID" -gt 0 ] || [ "$GROUPID" -gt 0 ]
then                  
        ORIGPASSWD=$(cat /etc/passwd | grep theia)
        ORIG_UID=$(echo $ORIGPASSWD | cut -f3 -d:)
        ORIG_GID=$(echo $ORIGPASSWD | cut -f4 -d:)
                                                                                
        if [ $USERID -ne $ORIG_UID ] || [ $GROUPID -ne $ORIG_GID ] \
        || [ $USERID -ne  $(ls -rn /workspace | awk 'NR==2 {print $3 }') ] \
        || [ $GROUPID -ne  $(ls -rn /workspace | awk 'NR==2 {print $4 }') ]
        then
                sed -i -e "s/:$ORIG_UID:$ORIG_GID:/:$USERID:$GROUPID:/" /etc/passwd
                sed -i -e "s/theia:x:$ORIG_GID:/theia:x:$GROUPID:/" /etc/group          
                ORIG_HOME=$(echo $ORIGPASSWD | cut -f6 -d:)                
                chown -R theia:theia ${ORIG_HOME}
                
                if [ $CHANGE_OWNER -gt 0 ]
                then 
                        chown -R theia:theia /workspace
                fi
        fi                                                  
fi

su theia -c "/usr/local/bin/node /home/theia/src-gen/backend/main.js $WORKSPACE --hostname=0.0.0.0"