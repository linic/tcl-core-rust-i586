
#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-rust-i586                     #
###################################################################

##################################################################
# The script generates the openssl-x.y.z-i586.tcz from
# libssl.so.x and libcrypto.so.x.
##################################################################

HOME_TC=/home/tc
PARAMETER_ERROR_MESSAGE="OPENSSL_VERSION is required. For example: ./generate-openssl-tczs.sh 3.0.0" 
if [ ! $# -eq 1 ]; then
  echo $PARAMETER_ERROR_MESSAGE
  exit 1
fi
OPENSSL_VERSION=$1
OPENSSL_LIB_SUFFIX=`echo $OPENSSL_VERSION | cut -d '.' -f 1`
OPENSSL_SQUASHFS_SOURCE_PATH=$HOME_TC/openssl
OPENSSL_TCZ=openssl-$OPENSSL_VERSION-i586.tcz
TODAY=`date "+%Y/%m/%d"`

# The current folder is usually /home/tc/ when this script is run in tinycore.
# The resource files are rust.tcz.dep and files in the info and info-openssl
# directories which are at the git root directory.
RESOURCE_FILES_DIRECTORY="."

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-openssl/1_title.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-openssl/1_title.txt is "\
    "required."
  exit 10
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-openssl/1_title-latest.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-openssl/1_title-latest.txt is "\
    "required."
  exit 11
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-openssl/2_description.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-openssl/2_description.txt is "\
    "required."
  exit 12
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-openssl/3_version.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-openssl/3_version.txt is "\
    "required."
  exit 13
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-openssl/4_author-copying-policy.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-openssl/4_author-copying-policy.txt is "\
    "required."
  exit 14
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-openssl/5_size.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-openssl/5_size.txt is "\
    "required."
  exit 15
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-openssl/6_extension_by-comments.txt is "\
    "required."
  exit 16
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-openssl/7_change-log.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-openssl/7_change-log.txt is "\
    "required."
  exit 17
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-openssl/8.1_current.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-openssl/8.1_current.txt is "\
    "required."
  exit 18
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-openssl/8.2_current.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-openssl/8.2_current.txt is "\
    "required."
  exit 19
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-openssl/8.3_current.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-openssl/8.3_current.txt is "\
    "required."
  exit 20
fi

# Generating the openssl-x.y.z-i586.tcz
cd $HOME_TC
if mksquashfs $OPENSSL_SQUASHFS_SOURCE_PATH ./$OPENSSL_TCZ; then
  echo "./openssl-$OPENSSL_VERSION-i586.tcz generated successfully."
  md5sum ./$OPENSSL_TCZ > ./$OPENSSL_TCZ.md5.txt
  if ! grep -q "$OPENSSL_VERSION" $RESOURCE_FILES_DIRECTORY/info-openssl/1_title.txt; then
    echo  "Title:          openssl-$OPENSSL_VERSION-i586-openssl.tcz\n"\
          > $RESOURCE_FILES_DIRECTORY/info-openssl/1_title.txt
    echo  "Version:        $OPENSSL_VERSION\n"\
          > $RESOURCE_FILES_DIRECTORY/info-openssl/2_version.txt
    echo  "Size:           `du -h ./$OPENSSL_TCZ | cut -f1`"\
          > $RESOURCE_FILES_DIRECTORY/info-openssl/5_size.txt
    echo  "Extension_by:   linic@hotmail.ca\n"\
          "Tags:           cryptography tls ssl dev\n"\
          "Comments:       Runs successfully on i686 CPUs and tested on the ThinkPad 560z.\n"\
          "                Required by rust toolchain.\n"\
          "                ----------\n"\
          "                This extension contains:\n"\
          "                  libssl.so.$OPENSSL_LIB_SUFFIX\n"\
          "                  libcrypto.so.$OPENSSL_LIB_SUFFIX\n"\
          "                from openssl - Apache 2.0 - https://www.openssl.org/\n"\
          "                This is the minimum used by rust.\n"\
          "                Built by linic@hotmail.ca using the method described in these URLs: \n"\
          "                  https://github.com/linic/tcl-core-rust-i586\n"\
          "                  https://github.com/linic/openssl-i586\n"\
          "                ----------\n"\
          > $RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt
    PREVIOUS_VERSION=`cat $RESOURCE_FILES_DIRECTORY/info-openssl/8.3_current.txt`
    PREVIOUS_UPDATED=`cat $RESOURCE_FILES_DIRECTORY/info-openssl/8.2_current.txt`
    echo $OPENSSL_VERSION > $RESOURCE_FILES_DIRECTORY/info-openssl/8.3_current.txt
    echo "$TODAY updated $PREVIOUS_VERSION -> " > $RESOURCE_FILES_DIRECTORY/info-openssl/8.2_current.txt
    echo  "                $PREVIOUS_UPDATED$PREVIOUS_VERSION\n"\
          >> $RESOURCE_FILES_DIRECTORY/info-openssl/7_change-log.txt
  fi
else
  echo "$OPENSSL_TCZ - mksquashfs failed!"
  exit 30
fi

cat $RESOURCE_FILES_DIRECTORY/info-openssl/1_title.txt\
  $RESOURCE_FILES_DIRECTORY/info-openssl/2_description.txt\
  $RESOURCE_FILES_DIRECTORY/info-openssl/3_version.txt\
  $RESOURCE_FILES_DIRECTORY/info-openssl/4_author-copying-policy.txt\
  $RESOURCE_FILES_DIRECTORY/info-openssl/5_size.txt\
  $RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt\
  $RESOURCE_FILES_DIRECTORY/info-openssl/7_change-log.txt\
  > ./$OPENSSL_TCZ.info
CURRENT1=`cat ./info-openssl/8.1_current.txt`
CURRENT2=`cat ./info-openssl/8.2_current.txt`
CURRENT3=`cat ./info-openssl/8.3_current.txt`
echo "$CURRENT1$CURRENT2$CURRENT3" >> ./$OPENSSL_TCZ.info

cat $RESOURCE_FILES_DIRECTORY/info-openssl/1_title-latest.txt\
  $RESOURCE_FILES_DIRECTORY/info-openssl/2_description.txt\
  $RESOURCE_FILES_DIRECTORY/info-openssl/3_version.txt\
  $RESOURCE_FILES_DIRECTORY/info-openssl/4_author-copying-policy.txt\
  $RESOURCE_FILES_DIRECTORY/info-openssl/5_size.txt\
  $RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt\
  $RESOURCE_FILES_DIRECTORY/info-openssl/7_change-log.txt\
  > ./openssl-i586.tcz.info
echo "$CURRENT1$CURRENT2$CURRENT3" >> ./openssl-i586.tcz.info

ln ./$OPENSSL_TCZ ./openssl-i586.tcz
md5sum ./openssl-i586.tcz > ./openssl-i586.tcz.md5.txt

