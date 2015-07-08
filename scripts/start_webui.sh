#!/bin/bash
export LOOKUPLOCATORS=$(ctx node properties lookuplocators)
export NIC_ADDR=$(ctx node properties ip)
INSTALL_PREFIX=$(ctx node properties xap_install_prefix)
export WEBUI_PORT=$(ctx node properties webui_port)

nohup $INSTALL_PREFIX/xap/bin/gs-webui.sh >/var/log/xap/webui.log 2>/var/log/xap/webui_err.log &
echo $! > /var/run/xap/gs-webui.pid
