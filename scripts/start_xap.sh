#!/bin/bash
export LOOKUPLOCATORS=$(ctx node properties lookuplocators)
export NIC_ADDR=$(ctx node properties ip)
INSTALL_PREFIX=$(ctx node properties xap_install_prefix)
GSA_GSM=$(ctx -j node properties gsa_gsm)
GSA_GLOBAL_GSM=$(ctx -j node properties gsa_global_gsm)
GSA_LUS=$(ctx -j node properties gsa_lus)
GSA_GLOBAL_LUS=$(ctx -j node properties gsa_global_lus)
GSA_GSC=$(ctx -j node properties gsa_gsc)

export EXT_JAVA_OPTIONS="-Dcom.gs.multicast.enabled=false"

GS_AGENT_ARGS="gsa.gsm $GSA_GSM gsa.global.gsm $GSA_GLOBAL_GSM gsa.lus $GSA_LUS gsa.global.lus $GSA_GLOBAL_LUS gsa.gsc $GSA_GSC"

ctx logger info "Starting gs-agent with arguments $GS_AGENT_ARGS"

nohup $INSTALL_PREFIX/xap/bin/gs-agent.sh $GS_AGENT_ARGS >/var/log/xap/agent.log 2>/var/log/xap/agent_err.log &
echo $! > /var/run/xap/gs-agent.pid
