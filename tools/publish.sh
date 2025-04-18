#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-rust-i586                     #
###################################################################

##################################################################
# Sign the artifacts, place them in a folder to be available on
# the local network and publish the docker image.
##################################################################

PARAMETER_ERROR_MESSAGE="RUST_VERSION OPENSSL_VERSION are required, for example: ./publish.sh 1.85.0 3.0.0"
if [ ! $# -ge 2 ]; then
  echo $PARAMETER_ERROR_MESSAGE
  exit 1
fi
RUST_VERSION=$1
OPENSSL_VERSION=$2

OPENSSL_TCZ=openssl-$OPENSSL_VERSION-i586.tcz
RUST_RELEASE_NAME=rust-$RUST_VERSION-i586
RUST_TCZ=$RUST_RELEASE_NAME.tcz
RUST_DOC_TCZ=$RUST_RELEASE_NAME-doc.tcz

if [ ! release/$RUST_VERSION/$RUST_TCZ ]; then
  echo "Please investigate why $RUST_TCZ is missing."
  exit 2
fi

if [ ! release/$RUST_VERSION/$RUST_TCZ.md5.txt ]; then
  echo "Please investigate why $RUST_TCZ.md5.txt is missing."
  exit 3
fi

if [ ! release/$RUST_VERSION/$RUST_TCZ.dep ]; then
  echo "Please investigate why $RUST_TCZ.dep is missing."
  exit 4
fi

if [ ! release/$RUST_VERSION/$RUST_TCZ.info ]; then
  echo "Please investigate why $RUST_TCZ.info is missing."
  exit 5
fi

if [ ! release/$RUST_VERSION/rust-i586.tcz.info ]; then
  echo "Please investigate why rust-i586.tcz.info is missing."
  exit 6
fi

if [ ! release/$RUST_VERSION/$RUST_DOC_TCZ ]; then
  echo "Please investigate why $RUST_DOC_TCZ is missing."
  exit 7
fi

if [ ! release/$RUST_VERSION/$RUST_DOC_TCZ.md5.txt ]; then
  echo "Please investigate why $RUST_DOC_TCZ.md5.txt is missing."
  exit 8
fi

if [ ! release/$RUST_VERSION/$RUST_DOC_TCZ.dep ]; then
  echo "Please investigate why $RUST_DOC_TCZ.dep is missing."
  exit 9
fi

if [ ! release/$RUST_VERSION/$RUST_DOC_TCZ.info ]; then
  echo "Please investigate why $RUST_DOC_TCZ.info is missing."
  exit 10
fi

if [ ! release/$RUST_VERSION/rust-i586-doc.tcz.info ]; then
  echo "Please investigate why rust-i586-doc.tcz.info is missing."
  exit 11
fi

if [ ! release/$RUST_VERSION/$OPENSSL_TCZ ]; then
  echo "Please investigate why $OPENSSL_TCZ is missing."
  exit 12
fi

if [ ! release/$RUST_VERSION/$OPENSSL_TCZ.md5.txt ]; then
  echo "Please investigate why $OPENSSL_TCZ.md5.txt is missing."
  exit 13
fi

if [ ! release/$RUST_VERSION/$OPENSSL_TCZ.info ]; then
  echo "Please investigate why $OPENSSL_TCZ.info is missing."
  exit 14
fi

if [ ! release/$RUST_VERSION/openssl-i586.tcz.info ]; then
  echo "Please investigate why openssl-i586.tcz.info is missing."
  exit 15
fi

if [ ! ./configuration/network_directory ]; then
  echo "Please create the ./configuration/network_directory from the root directory of the git repo."
  exit 20
fi

if [ ! ./configuration/network_directory_owner ]; then
  echo "Please create the ./configuration/network_directory_owner from the root directory of the git repo."
  exit 21
fi

HOST_NETWORK_DIRECTORY=`cat ./configuration/network_directory`
HOST_NETWORK_DIRECTORY_OWNER=`cat ./configuration/network_directory_owner`

echo "Signing, making artifacts available on the local network, publishing to hub.docker.com..."

cd ./release/$RUST_VERSION/
ls .
echo "$RUST_TCZ $RUST_DOC_TCZ $OPENSSL_TCZ $HOST_NETWORK_DIRECTORY $HOST_NETWORK_DIRECTORY_OWNER"

if [ -f $RUST_TCZ.sig ]; then
  echo "Skipping gpg --detach-sign because files already exist."
else
  gpg --detach-sign $RUST_TCZ
  gpg --detach-sign rust-i586.tcz
  gpg --detach-sign $RUST_DOC_TCZ
  gpg --detach-sign rust-i586-doc.tcz
  gpg --detach-sign $OPENSSL_TCZ
  gpg --detach-sign openssl-i586.tcz
fi

sudo cp $RUST_TCZ $HOST_NETWORK_DIRECTORY
sudo cp $RUST_TCZ.md5.txt $HOST_NETWORK_DIRECTORY
sudo cp $RUST_TCZ.dep $HOST_NETWORK_DIRECTORY
sudo cp $RUST_TCZ.info $HOST_NETWORK_DIRECTORY
sudo cp $RUST_TCZ.sig $HOST_NETWORK_DIRECTORY
sudo cp rust-i586.tcz.md5.txt $HOST_NETWORK_DIRECTORY
sudo cp rust-i586.tcz.info $HOST_NETWORK_DIRECTORY
sudo cp rust-i586.tcz.sig $HOST_NETWORK_DIRECTORY

sudo cp $RUST_DOC_TCZ $HOST_NETWORK_DIRECTORY
sudo cp $RUST_DOC_TCZ.md5.txt $HOST_NETWORK_DIRECTORY
sudo cp $RUST_DOC_TCZ.dep $HOST_NETWORK_DIRECTORY
sudo cp $RUST_DOC_TCZ.info $HOST_NETWORK_DIRECTORY
sudo cp $RUST_DOC_TCZ.sig $HOST_NETWORK_DIRECTORY
sudo cp rust-i586-doc.tcz.md5.txt $HOST_NETWORK_DIRECTORY
sudo cp rust-i586-doc.tcz.dep $HOST_NETWORK_DIRECTORY
sudo cp rust-i586-doc.tcz.info $HOST_NETWORK_DIRECTORY
sudo cp rust-i586-doc.tcz.sig $HOST_NETWORK_DIRECTORY

sudo cp $OPENSSL_TCZ $HOST_NETWORK_DIRECTORY
sudo cp $OPENSSL_TCZ.md5.txt $HOST_NETWORK_DIRECTORY
sudo cp $OPENSSL_TCZ.info $HOST_NETWORK_DIRECTORY
sudo cp $OPENSSL_TCZ.sig $HOST_NETWORK_DIRECTORY
sudo cp openssl-i586.tcz.md5.txt $HOST_NETWORK_DIRECTORY
sudo cp openssl-i586.tcz.info $HOST_NETWORK_DIRECTORY
sudo cp openssl-i586.tcz.sig $HOST_NETWORK_DIRECTORY

sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$RUST_TCZ
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$RUST_TCZ.md5.txt
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$RUST_TCZ.dep
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$RUST_TCZ.info
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$RUST_TCZ.sig
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/rust-i586.tcz.md5.txt
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/rust-i586.tcz.info
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/rust-i586.tcz.sig

sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$RUST_DOC_TCZ
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$RUST_DOC_TCZ.md5.txt
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$RUST_DOC_TCZ.dep
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$RUST_DOC_TCZ.info
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$RUST_DOC_TCZ.sig
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/rust-i586-doc.tcz.md5.txt
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/rust-i586-doc.tcz.dep
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/rust-i586-doc.tcz.info
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/rust-i586-doc.tcz.sig

sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$OPENSSL_TCZ
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$OPENSSL_TCZ.md5.txt
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$OPENSSL_TCZ.info
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/$OPENSSL_TCZ.sig
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/openssl-i586.tcz.md5.txt
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/openssl-i586.tcz.info
sudo chown $HOST_NETWORK_DIRECTORY_OWNER:$HOST_NETWORK_DIRECTORY_OWNER $HOST_NETWORK_DIRECTORY/openssl-i586.tcz.sig

if [ -f $HOST_NETWORK_DIRECTORY/rust-i586.tcz ]; then
  sudo rm $HOST_NETWORK_DIRECTORY/rust-i586.tcz
fi
sudo ln $HOST_NETWORK_DIRECTORY/$RUST_TCZ $HOST_NETWORK_DIRECTORY/rust-i586.tcz
if [ -f $HOST_NETWORK_DIRECTORY/rust-i586.tcz.dep ]; then
  sudo rm $HOST_NETWORK_DIRECTORY/rust-i586.tcz.dep
fi
sudo ln $HOST_NETWORK_DIRECTORY/$RUST_TCZ.dep $HOST_NETWORK_DIRECTORY/rust-i586.tcz.dep

if [ -f $HOST_NETWORK_DIRECTORY/rust-i586-doc.tcz ]; then
  sudo rm $HOST_NETWORK_DIRECTORY/rust-i586-doc.tcz
fi
sudo ln $HOST_NETWORK_DIRECTORY/$RUST_DOC_TCZ $HOST_NETWORK_DIRECTORY/rust-i586-doc.tcz

if [ -f $HOST_NETWORK_DIRECTORY/openssl-i586.tcz ]; then
  sudo rm $HOST_NETWORK_DIRECTORY/openssl-i586.tcz
fi
sudo ln $HOST_NETWORK_DIRECTORY/$OPENSSL_TCZ $HOST_NETWORK_DIRECTORY/openssl-i586.tcz

if [ -f ../../configuration/ssh_user ] && [ -f ../../configuration/ssh_remote_host ] && [ -f ../../configuration/ssh_remote_directory ]; then
  SSH_USER=`cat ../../configuration/ssh_user`
  SSH_REMOTE_HOST=`cat ../../configuration/ssh_remote_host`
  SSH_REMOTE_DIRECTORY=`cat ../../configuration/ssh_remote_directory`

  echo "$SSH_USER $SSH_REMOTE_HOST $SSH_REMOTE_DIRECTORY"

  scp rust-$RUST_VERSION* $SSH_USER@$SSH_REMOTE_HOST:$SSH_REMOTE_DIRECTORY/
  scp openssl-$OPENSSL_VERSION* $SSH_USER@$SSH_REMOTE_HOST:$SSH_REMOTE_DIRECTORY/
  scp rust-i586-doc.tcz.* $SSH_USER@$SSH_REMOTE_HOST:$SSH_REMOTE_DIRECTORY/
  scp rust-i586.tcz.* $SSH_USER@$SSH_REMOTE_HOST:$SSH_REMOTE_DIRECTORY/
  scp openssl-i586.tcz.* $SSH_USER@$SSH_REMOTE_HOST:$SSH_REMOTE_DIRECTORY/
  ssh $SSH_USER@$SSH_REMOTE_HOST "rm $SSH_REMOTE_DIRECTORY/rust-i586.tcz; "\
    "rm $SSH_REMOTE_DIRECTORY/rust-i586.tcz.dep; "\
    "rm $SSH_REMOTE_DIRECTORY/rust-i586-doc.tcz; "\
    "rm $SSH_REMOTE_DIRECTORY/openssl-i586.tcz; "\
    "ln $SSH_REMOTE_DIRECTORY/$RUST_TCZ $SSH_REMOTE_DIRECTORY/rust-i586.tcz; "\
    "ln $SSH_REMOTE_DIRECTORY/$RUST_TCZ.dep $SSH_REMOTE_DIRECTORY/rust-i586.tcz.dep; "\
    "ln $SSH_REMOTE_DIRECTORY/$RUST_DOC_TCZ $SSH_REMOTE_DIRECTORY/rust-i586-doc.tcz; "\
    "ln $SSH_REMOTE_DIRECTORY/$OPENSSL_TCZ $SSH_REMOTE_DIRECTORY/openssl-i586.tcz; "
fi

echo "Push image to hub.docker.com? (y/n): "
read push_response

if [ "$push_response" = "y" ]; then
  sudo docker push linichotmailca/tcl-core-rust-i586:$RUST_VERSION
  sudo docker push linichotmailca/tcl-core-rust-i586:latest
fi

