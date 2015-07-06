#!/bin/bash

killtree() {
    local _pid=$1
    local _sig=${2:-9}
    # needed to stop quickly forking parent from producing
    # children between child killing and parent killing
    kill -stop ${_pid}
    for _child in $(ps -o pid --no-headers --ppid ${_pid}); do
        killtree ${_child} ${_sig}
    done
    kill -${_sig} ${_pid}
}

if [ -f /var/run/xap/gs-agent.pid ]; then
    PID=$(cat /var/run/xap/gs-agent.pid)
    ctx logger info "Killing gs-agent with PID=$PID"
    killtree $PID
    rm /var/run/xap/gs-agent.pid
else
    ctx logger error "PID file /var/run/xap/gs-agent.pid does not exist!"
fi
