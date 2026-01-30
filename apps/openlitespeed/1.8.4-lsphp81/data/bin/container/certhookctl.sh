#!/bin/bash
BOTCRON='/var/spool/cron/crontabs/root'

cert_hook(){
    grep 'acme' ${BOTCRON} >/dev/null
    if [ ${?} = 0 ]; then
        grep 'lswsctrl' ${BOTCRON} >/dev/null
        if [ ${?} = 0 ]; then
            echo 'Hook already exist, skip!'
        else
            sed -i 's/--cron/--cron --renew-hook "\/usr\/local\/lsws\/bin\/lswsctrl restart"/g' ${BOTCRON}
        fi    
    else
        echo "[X] ${BOTCRON} does not exist, please check it later!"
    fi
}

cert_hook