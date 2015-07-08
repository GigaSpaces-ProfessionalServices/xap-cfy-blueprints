#!/bin/bash
INSTALL_PREFIX=$(ctx node properties xap_install_prefix)

sudo rm -rf $INSTALL_PREFIX/xap_mvn_app/
