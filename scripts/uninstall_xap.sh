#!/bin/bash
INSTALL_PREFIX=$(ctx node properties xap_install_prefix)

sudo rm -rf $INSTALL_PREFIX/xap
sudo rm -rf /var/log/xap/
sudo rm -rf /var/run/xap/
