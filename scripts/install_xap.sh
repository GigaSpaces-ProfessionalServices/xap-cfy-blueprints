#!/bin/bash

APT_GET_CMD=$(which apt-get)

DOWNLOAD_URL=$(ctx node properties xap_download_url)
LICENSE_KEY=$(ctx node properties xap_license_key)
INSTALL_PREFIX=$(ctx node properties xap_install_prefix)

ctx logger info "Installing JDK, unzip, wget..."

if [[ ! -z $APT_GET_CMD ]]; then
  ctx logger info "Using apt-get for installations"
  sudo apt-get install -y openjdk-7-jdk unzip wget || exit $?
else
  ctx logger error "Package manager is not available for installations"
  exit 50
fi

TMP_DIR=$(mktemp -d)

ctx logger info "Downloading XAP package from $DOWNLOAD_URL to $TMP_DIR"

cd $TMP_DIR
wget $DOWNLOAD_URL

XAP_ZIPFILE=$(ls)

unzip $XAP_ZIPFILE
rm $XAP_ZIPFILE

XAP_DIRNAME=$(ls)

ctx logger info "Moving $XAP_DIRNAME to $INSTALL_PREFIX/xap"

sudo mv $XAP_DIRNAME $INSTALL_PREFIX/xap

ctx logger info "Applying license key"

sed -i "s|Enter Your License Here....|$LICENSE_KEY|" $INSTALL_PREFIX/xap/gslicense.xml

INSTALL_USER=$(whoami)
ctx logger info "Creating /var dirs and chowining them to $INSTALL_USER"
sudo mkdir /var/log/xap/
sudo chown $INSTALL_USER /var/log/xap/
sudo mkdir /var/run/xap/
sudo chown $INSTALL_USER /var/run/xap/

rm -rf $TMP_DIR
