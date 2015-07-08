#!/bin/bash
INSTALL_PREFIX=$(ctx node properties xap_install_prefix)
export LOOKUPLOCATORS=$(ctx node properties lookuplocators)

cd $INSTALL_PREFIX/xap_mvn_app/

mvn os:deploy -Dlocators=$LOOKUPLOCATORS -Dtimeout=60000 >/var/log/xap/mvn_deploy.log 2>/var/log/xap/mvn_deploy_err.log
