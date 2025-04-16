#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-rust-i586                     #
###################################################################

##################################################################
# The script generates the 
# rust-x.y.z-i586.tcz and rust-x.y.z-i586-doc.tcz from a tar.
##################################################################

HOME_TC=/home/tc
RUST_TOOLCHAIN_NAME=rust-nightly-i586-unknown-linux-gnu
PARAMETER_ERROR_MESSAGE="RUST_VERSION is required. For example: ./generate-rust-tczs.sh 1.85.0"
if [ ! $# -eq 1 ]; then
  echo $PARAMETER_ERROR_MESSAGE
  exit 1
fi
RUST_VERSION=$1
RUST_RELEASE_NAME=rust-$RUST_VERSION-i586
RUST_TCZ=$RUST_RELEASE_NAME.tcz
RUST_DOC_TCZ=$RUST_RELEASE_NAME-doc.tcz
RUST_TOOLCHAIN_TAR=$RUST_TOOLCHAIN_NAME.tar.gz
RUST_TOOLCHAIN_TAR_PATH=/rust/build/dist/$RUST_TOOLCHAIN_TAR
RUST_INSTALL_PATH=$HOME_TC/$RUST_RELEASE_NAME
RUST_DOC_PATH=$RUST_INSTALL_PATH-doc
RUST_DOC_TREE=$RUST_DOC_PATH/usr/local/share

# Generating the rust-x.y.z-i586.tcz and rust-x.y.z-i586-doc.tcz
# Swap -xf for -xvf to output in the console each file that's extracted.
tar -xf $RUST_TOOLCHAIN_TAR
mkdir $RUST_INSTALL_PATH
mkdir $RUST_INSTALL_PATH/etc
mkdir -p $RUST_DOC_TREE
# Add --verbose after install.sh to have the details of the install.
sh ./$RUST_TOOLCHAIN_NAME/install.sh --verbose --destdir=$RUST_INSTALL_PATH --sysconfdir=$RUST_INSTALL_PATH/etc
# Since ldconfig fails during the install.sh script and I don't want to run the install with sudo.
sudo ldconfig
# Move the documents to create a rust-x.y.z-i586-doc.tcz
if [ -d $RUST_INSTALL_PATH/usr/local/share ] && [ -d $RUST_DOC_TREE ]; then
  mv $RUST_INSTALL_PATH/usr/local/share $RUST_DOC_TREE
else
  echo `pwd`
  echo "Either $RUST_INSTALL_PATH/usr/local/share  or $RUST_DOC_TREE is missing."
  echo `ls $RUST_INSTALL_PATH/usr/local/share`
  echo `ls $RUST_DOC_TREE`
  exit 10
fi

if ! mksquashfs $RUST_INSTALL_PATH $RUST_TCZ; then
  echo "mksquashfs $RUST_INSTALL_PATH $RUST_TCZ failed!"
  exit 20
fi
# Serves as the latest.
ln ./$RUST_TCZ ./rust-i586.tcz

if ! mksquashfs $RUST_DOC_PATH $RUST_DOC_TCZ; then
  echo "mksquashfs $RUST_DOC_PATH $RUST_DOC_TCZ failed!"
  exit 30
fi
ln ./$RUST_DOC_TCZ ./rust-i586-doc.tcz

