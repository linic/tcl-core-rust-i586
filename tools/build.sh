#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-rust-i586                     #
###################################################################

##################################################################
# The script checks all dependencies are available.
# It builds the docker image which builds the custom
# rust-x.y.z-i586.tcz and rust-x.y.z-i586-doc.tcz and their
# related .tcz.dep and .tcz.info
# in a release/$RUST_VERSION directory (for example release/1.85.0/).
##################################################################

PARAMETER_ERROR_MESSAGE="ARCHITECTURE OPENSSL_VERSION RUST_VERSION TCL_VERSION are required for example: ./build.sh x86 3.0.0 1.85.0 16.x"
if [ ! $# -eq 4 ]; then
  echo $PARAMETER_ERROR_MESSAGE
  exit 1
fi
ARCHITECTURE=$1
if [ $ARCHITECTURE != "x86" ]; then
  echo "ARCHITECTURE can only be x86 for now."
  exit 2
fi
OPENSSL_VERSION=$2
RUST_VERSION=$3
TCL_VERSION=$4

OPENSSL_LIB_SUFFIX=`echo $OPENSSL_VERSION | cut -d '.' -f 1`
OPENSSL_TCZ=openssl-$OPENSSL_VERSION-i586.tcz

RUST_RELEASE_NAME=rust-$RUST_VERSION-i586
RUST_TCZ=$RUST_RELEASE_NAME.tcz
RUST_DOC_TCZ=$RUST_RELEASE_NAME-doc.tcz

if [ ! Dockerfile ]; then
  echo "Please make sure this folder is the base folder of "\
    "https://github.com/linic/tcl-core-rust-i586 since Dockerfile is "\
    "required."
  exit 2
fi

if [ ! echo_sleep ]; then
  echo "Please make sure this folder is the base folder of "\
    "https://github.com/linic/tcl-core-rust-i586 since "\
    "echo_sleep is required"
  exit 3
fi
if [ ! -f docker-compose.yml ] || ! grep -q "$RUST_VERSION" docker-compose.yml || ! grep -q "$TCL_VERSION" docker-compose.yml || ! grep -q "$OPENSSL_VERSION" docker-compose.yml; then
  echo "Did not find $RUST_VERSION or $TCL_VERSION in docker-compose.yml. Rewriting docker-compose.yml."
  echo "services:\n"\
    " main:\n"\
    "   build:\n"\
    "     context: .\n"\
    "     args:\n"\
    "       - ARCHITECTURE=$ARCHITECTURE\n"\
    "       - OPENSSL_LIB_SUFFIX=$OPENSSL_LIB_SUFFIX\n"\
    "       - OPENSSL_VERSION=$OPENSSL_VERSION\n"\
    "       - RUST_VERSION=$RUST_VERSION\n"\
    "       - TCL_VERSION=$TCL_VERSION\n"\
    "     dockerfile: Dockerfile\n"\
    "     tags:\n"\
    "       - linichotmailca/tcl-core-rust-i586:$RUST_VERSION\n"\
    "       - linichotmailca/tcl-core-rust-i586:latest\n" > docker-compose.yml
fi

echo "Requirements are met. Building..."
echo "  $RUST_TCZ"
echo "  $RUST_DOC_TCZ"

if sudo docker compose --progress=plain -f docker-compose.yml build; then
  echo "rust TCZs built successfully."
else
  echo "rust TCZs build failure!"
  exit 30
fi

sudo docker compose --progress=plain -f docker-compose.yml up --detach

mkdir -p ./release/$RUST_VERSION/
cd ./release/$RUST_VERSION/

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/$RUST_TCZ ./; then
  echo "Failed to copy $RUST_TCZ!"
  exit 31
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/$RUST_TCZ.md5.txt ./; then
  echo "Failed to copy $RUST_TCZ.md5.txt!"
  exit 32
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/$RUST_TCZ.info ./; then
  echo "Failed to copy $RUST_TCZ.info!"
  exit 33
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/rust-i586.tcz.md5.txt ./; then
  echo "Failed to copy rust-i586.md5.txt!"
  exit 34
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/rust-i586.tcz.info ./; then
  echo "Failed to copy rust-i586.info!"
  exit 35
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/$RUST_TCZ.dep ./; then
  echo "Failed to copy $RUST_TCZ.dep!"
  exit 36
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/$RUST_DOC_TCZ ./; then
  echo "Failed to copy $RUST_DOC_TCZ!"
  exit 40
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/$RUST_DOC_TCZ.md5.txt ./; then
  echo "Failed to copy $RUST_DOC_TCZ.md5.txt!"
  exit 41
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/$RUST_DOC_TCZ.info ./; then
  echo "Failed to copy $RUST_DOC_TCZ.info!"
  exit 42
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/$RUST_DOC_TCZ.dep ./; then
  echo "Failed to copy $RUST_DOC_TCZ.dep!"
  exit 43
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/rust-i586-doc.tcz.md5.txt ./; then
  echo "Failed to copy rust-i586-doc.tcz.md5.txt!"
  exit 44
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/rust-i586-doc.tcz.dep ./; then
  echo "Failed to copy rust-i586-doc.tcz.dep!"
  exit 45
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/rust-i586-doc.tcz.info ./; then
  echo "Failed to copy rust-i586-doc.tcz.info!"
  exit 46
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/$OPENSSL_TCZ ./; then
  echo "Failed to copy $OPENSSL_TCZ!"
  exit 50
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/$OPENSSL_TCZ.md5.txt ./; then
  echo "Failed to copy $OPENSSL_TCZ.md5.txt!"
  exit 51
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/$OPENSSL_TCZ.info ./; then
  echo "Failed to copy $OPENSSL_TCZ.info!"
  exit 52
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/openssl-i586.tcz.md5.txt ./; then
  echo "Failed to copy $OPENSSL_TCZ.md5.txt!"
  exit 53
fi

if ! sudo docker cp tcl-core-rust-i586-main-1:/home/tc/openssl-i586.tcz.info ./; then
  echo "Failed to copy $OPENSSL_TCZ.info!"
  exit 54
fi

if [ -f ../../configuration/current_user ]; then
  CURRENT_USER=`cat ../../configuration/current_user`
  sudo chown $CURRENT_USER:$CURRENT_USER *
fi

if [ -f ./rust-i586.tcz ]; then
  rm ./rust-i586.tcz
fi
ln ./$RUST_TCZ ./rust-i586.tcz
if [ -f ./rust-i586.tcz.dep ]; then
  rm ./rust-i586.tcz.dep
fi
ln ./$RUST_TCZ.dep ./rust-i586.tcz.dep

if [ -f ./rust-i586-doc.tcz ]; then
  rm ./rust-i586-doc.tcz
fi
ln ./$RUST_DOC_TCZ ./rust-i586-doc.tcz

if [ -f ./openssl-i586.tcz ]; then
  rm ./openssl-i586.tcz
fi
ln ./$OPENSSL_TCZ ./openssl-i586.tcz

cd ../..

# Copy back the info and info-doc files.
sudo docker cp tcl-core-rust-i586-main-1:/home/tc/info .
sudo docker cp tcl-core-rust-i586-main-1:/home/tc/info-doc .
sudo docker cp tcl-core-rust-i586-main-1:/home/tc/info-openssl .
if [ -f configuration/current_user ]; then
  CURRENT_USER=`cat configuration/current_user`
  sudo chown $CURRENT_USER:$CURRENT_USER info/*
  sudo chown $CURRENT_USER:$CURRENT_USER info-doc/*
  sudo chown $CURRENT_USER:$CURRENT_USER info-openssl/*
fi


sudo docker compose --progress=plain -f docker-compose.yml down

