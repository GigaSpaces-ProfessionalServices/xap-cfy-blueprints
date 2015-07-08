#!/bin/bash

APT_GET_CMD=$(which apt-get)

DOWNLOAD_URL=$(ctx node properties download_url)
INSTALL_PREFIX=$(ctx node properties xap_install_prefix)

ctx logger info "Installing maven..."

if [[ ! -z $APT_GET_CMD ]]; then
  ctx logger info "Using apt-get for installations"
  sudo apt-get install -y maven || exit $?
else
  ctx logger error "Package manager is not available for installations"
  exit 50
fi

ctx logger info "Installing openspaces maven plugin"

export JAVA_HOME=$(echo /usr/lib/jvm/java-7-*)
/opt/xap/tools/maven/installmavenrep.sh


TMP_DIR=$(mktemp -d)

ctx logger info "Downloading XAP package from $DOWNLOAD_URL to $TMP_DIR"

cd $TMP_DIR
wget $DOWNLOAD_URL

APP_ZIPFILE=$(ls)

unzip $APP_ZIPFILE
rm $APP_ZIPFILE


sudo mkdir $INSTALL_PREFIX/xap_mvn_app/
INSTALL_USER=$(whoami)
sudo chown $INSTALL_USER $INSTALL_PREFIX/xap_mvn_app/

ctx logger info "Moving $XAP_DIRNAME to $INSTALL_PREFIX/xap_mvn_app/"

mv ./* $INSTALL_PREFIX/xap_mvn_app/

rm -rf $TMP_DIR

ctx logger info "Packaging application"

cd $INSTALL_PREFIX/xap_mvn_app/
mvn package
