#!/bin/bash
#export LOOKUPLOCATORS=$(ctx node properties lookuplocators)
#export NIC_ADDR=$(ctx node properties ip)
NETWORK_INTERFACE=$(ctx node properties network_interface)
export NIC_ADDR=$(ip addr | grep inet | grep $NETWORK_INTERFACE | awk -F" " '{print $2}'| sed -e 's/\/.*$//')
INSTALL_PREFIX=$(ctx node properties xap_install_prefix)
export WEBUI_PORT=$(ctx node properties webui_port)

#export EXT_JAVA_OPTIONS="-Dcom.gs.multicast.enabled=false"

nohup $INSTALL_PREFIX/xap/bin/gs-webui.sh >/var/log/xap/webui.log 2>/var/log/xap/webui_err.log &
echo $! > /var/run/xap/gs-webui.pid
