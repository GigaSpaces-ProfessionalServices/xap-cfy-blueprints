#!/bin/bash

killtree() {
    local _pid=$1
    local _sig=${2:-15}
    # needed to stop quickly forking parent from producing
    # children between child killing and parent killing
    kill -stop ${_pid}
    for _child in $(ps -o pid --no-headers --ppid ${_pid}); do
        killtree ${_child} ${_sig}
    done
    kill -${_sig} ${_pid}
}

if [ -f /var/run/xap/gs-webui.pid ]; then
    PID=$(cat /var/run/xap/gs-webui.pid)
    ctx logger info "Killing gs-webui with PID=$PID"
    killtree $PID 9
    rm /var/run/xap/gs-webui.pid
else
    ctx logger error "PID file /var/run/xap/gs-webui.pid does not exist!"
fi
