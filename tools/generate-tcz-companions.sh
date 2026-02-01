#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-rust-i586                     #
###################################################################

##################################################################
# The script checks all dependencies are available.
# It generates the .tcz.info .tcz.dep .tcz.md5.txt from
# rust-x.y.z-i586.tcz and rust-x.y.z-i586-doc.tcz
##################################################################

PARAMETER_ERROR_MESSAGE="RUST_VERSION for example: ./generate-tcz-companions.sh 1.85.0"
if [ ! $# -eq 1 ]; then
  echo $PARAMETER_ERROR_MESSAGE
  exit 1
fi
RUST_VERSION=$1
RUST_TCZ=rust-$RUST_VERSION-i586.tcz
RUST_DOC_TCZ=rust-$RUST_VERSION-i586-doc.tcz
# The current folder is usually /home/tc/ when this script is run in tinycore.
# The resource files are rust.tcz.dep and files in the info and info-doc
# directories which are at the git root directory.
RESOURCE_FILES_DIRECTORY="."

if [ ! -f $RESOURCE_FILES_DIRECTORY/rust.tcz.dep ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since rust.tcz.dep is "\
    "required."
  exit 2
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info/1_title.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info/1_title.txt is "\
    "required."
  exit 10
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info/1_title-latest.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info/1_title-latest.txt is "\
    "required."
  exit 11
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info/2_description.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info/2_description.txt is "\
    "required."
  exit 12
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info/3_version.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info/3_version.txt is "\
    "required."
  exit 13
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info/4_author-copying-policy.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info/4_author-copying-policy.txt is "\
    "required."
  exit 14
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info/5_size.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info/5_size.txt is "\
    "required."
  exit 15
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info/6_extension_by-comments.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info/6_extension_by-comments.txt is "\
    "required."
  exit 16
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info/7_change-log.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info/7_change-log.txt is "\
    "required."
  exit 17
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info/8.1_current.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info/8.1_current.txt is "\
    "required."
  exit 18
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info/8.2_current.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info/8.2_current.txt is "\
    "required."
  exit 19
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info/8.3_current.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info/8.3_current.txt is "\
    "required."
  exit 20
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-doc/1_title.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-doc/1_title.txt is "\
    "required."
  exit 30
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-doc/1_title-latest.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-doc/1_title-latest.txt is "\
    "required."
  exit 31
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-doc/2_description.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-doc/2_description.txt is "\
    "required."
  exit 32
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-doc/3_version.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-doc/3_version.txt is "\
    "required."
  exit 33
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-doc/4_author-copying-policy.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-doc/4_author-copying-policy.txt is "\
    "required."
  exit 34
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-doc/5_size.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-doc/5_size.txt is "\
    "required."
  exit 35
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-doc/6_extension_by-comments.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-doc/6_extension_by-comments.txt is "\
    "required."
  exit 36
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-doc/7_change-log.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-doc/7_change-log.txt is "\
    "required."
  exit 37
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-doc/8.1_current.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-doc/8.1_current.txt is "\
    "required."
  exit 38
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-doc/8.2_current.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-doc/8.2_current.txt is "\
    "required."
  exit 39
fi

if [ ! -f $RESOURCE_FILES_DIRECTORY/info-doc/8.3_current.txt ]; then
  echo "Please make sure the current directory is the release/x.y.z/ "\
    "from the root directory of "\
    "https://github.com/linic/tcl-core-rust-i586 since info-doc/8.3_current.txt is "\
    "required."
  exit 40
fi

TODAY=`date "+%Y/%m/%d"`
if md5sum ./$RUST_TCZ > ./$RUST_TCZ.md5.txt; then
  cat ./$RUST_TCZ.md5.txt
  if ! grep -q "$RUST_VERSION" $RESOURCE_FILES_DIRECTORY/info/1_title.txt; then
    echo "Title:          $RUST_TCZ" > $RESOURCE_FILES_DIRECTORY/info/1_title.txt
    echo "Version:        $RUST_VERSION" > $RESOURCE_FILES_DIRECTORY/info/3_version.txt
    echo "Size:           `du -h ./$RUST_TCZ | cut -f1`" > $RESOURCE_FILES_DIRECTORY/info/5_size.txt
    PREVIOUS_VERSION=`cat $RESOURCE_FILES_DIRECTORY/info/8.3_current.txt`
    PREVIOUS_UPDATED=`cat $RESOURCE_FILES_DIRECTORY/info/8.2_current.txt`
    echo $RUST_VERSION > $RESOURCE_FILES_DIRECTORY/info/8.3_current.txt
    echo "$TODAY updated $PREVIOUS_VERSION -> " > $RESOURCE_FILES_DIRECTORY/info/8.2_current.txt
    echo "                $PREVIOUS_UPDATED$PREVIOUS_VERSION" >> $RESOURCE_FILES_DIRECTORY/info/7_change-log.txt
  fi
else
  echo "md5sum of ./$RUST_TCZ failed! Please investigae."
  exit 60
fi

if md5sum ./$RUST_DOC_TCZ > ./$RUST_DOC_TCZ.md5.txt; then
  cat ./$RUST_DOC_TCZ.md5.txt
  if ! grep -q "$RUST_VERSION" $RESOURCE_FILES_DIRECTORY/info-doc/1_title.txt; then
    echo "Title:          $RUST_DOC_TCZ" | tee $RESOURCE_FILES_DIRECTORY/info-doc/1_title.txt
    echo "Version:        $RUST_VERSION" | tee $RESOURCE_FILES_DIRECTORY/info-doc/3_version.txt
    echo "Size:           `du -h ./$RUST_DOC_TCZ | cut -f1`" | tee $RESOURCE_FILES_DIRECTORY/info-doc/5_size.txt
    PREVIOUS_VERSION=`cat $RESOURCE_FILES_DIRECTORY/info-doc/8.3_current.txt`
    echo $PREVIOUS_VERSION
    PREVIOUS_UPDATED=`cat $RESOURCE_FILES_DIRECTORY/info-doc/8.2_current.txt`
    echo $PREVIOUS_UPDATED
    echo $RUST_VERSION | tee $RESOURCE_FILES_DIRECTORY/info-doc/8.3_current.txt
    echo "$TODAY updated $PREVIOUS_VERSION -> " | tee $RESOURCE_FILES_DIRECTORY/info-doc/8.2_current.txt
    CHANGE_LOG=`cat $RESOURCE_FILES_DIRECTORY/info-doc/7_change-log.txt`
    if [ -z "$PREVIOUS_UPDATED" ] && [ -z "$CHANGE_LOG" ]; then
      echo "" | tee -a $RESOURCE_FILES_DIRECTORY/info-doc/7_change-log.txt
    elif [ -z "$CHANGE_LOG" ]; then
      echo "Change-log:     $PREVIOUS_UPDATED" | tee -a $RESOURCE_FILES_DIRECTORY/info-doc/7_change-log.txt
    else
      echo "                $PREVIOUS_UPDATED$PREVIOUS_VERSION" | tee -a $RESOURCE_FILES_DIRECTORY/info-doc/7_change-log.txt
    fi
  fi
else
  echo "md5sum of ./$RUST_DOC_TCZ failed! Please investigate."
  exit 61
fi

cat $RESOURCE_FILES_DIRECTORY/info/1_title.txt\
  $RESOURCE_FILES_DIRECTORY/info/2_description.txt\
  $RESOURCE_FILES_DIRECTORY/info/3_version.txt\
  $RESOURCE_FILES_DIRECTORY/info/4_author-copying-policy.txt\
  $RESOURCE_FILES_DIRECTORY/info/5_size.txt\
  $RESOURCE_FILES_DIRECTORY/info/6_extension_by-comments.txt\
  $RESOURCE_FILES_DIRECTORY/info/7_change-log.txt\
  > ./$RUST_TCZ.info
CURRENT1=`cat ./info/8.1_current.txt`
CURRENT2=`cat ./info/8.2_current.txt`
CURRENT3=`cat ./info/8.3_current.txt`
echo "$CURRENT1$CURRENT2$CURRENT3" >> ./$RUST_TCZ.info

cat $RESOURCE_FILES_DIRECTORY/info/1_title-latest.txt\
  $RESOURCE_FILES_DIRECTORY/info/2_description.txt\
  $RESOURCE_FILES_DIRECTORY/info/3_version.txt\
  $RESOURCE_FILES_DIRECTORY/info/4_author-copying-policy.txt\
  $RESOURCE_FILES_DIRECTORY/info/5_size.txt\
  $RESOURCE_FILES_DIRECTORY/info/6_extension_by-comments.txt\
  $RESOURCE_FILES_DIRECTORY/info/7_change-log.txt\
  > ./rust-i586.tcz.info
echo "$CURRENT1$CURRENT2$CURRENT3" >> ./rust-i586.tcz.info

if [ -z "`cat $RESOURCE_FILES_DIRECTORY/info-doc/8.2_current.txt`" ]; then
  echo "$TODAY      first version" > $RESOURCE_FILES_DIRECTORY/info-doc/8.2_current.txt

  cat $RESOURCE_FILES_DIRECTORY/info-doc/1_title.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/2_description.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/3_version.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/4_author-copying-policy.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/5_size.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/6_extension_by-comments.txt\
    > ./$RUST_DOC_TCZ.info
  echo "$TODAY      first version" >> ./$RUST_DOC_TCZ.info

  cat $RESOURCE_FILES_DIRECTORY/info-doc/1_title-latest.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/2_description.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/3_version.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/4_author-copying-policy.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/5_size.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/6_extension_by-comments.txt\
    > ./rust-i586-doc.tcz.info
  echo "$TODAY      first version" >> ./rust-i586-doc.tcz.info
else
  cat $RESOURCE_FILES_DIRECTORY/info-doc/1_title.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/2_description.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/3_version.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/4_author-copying-policy.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/5_size.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/6_extension_by-comments.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/7_change-log.txt\
    > ./$RUST_DOC_TCZ.info
  CURRENT1=`cat ./info-doc/8.1_current.txt`
  CURRENT2=`cat ./info-doc/8.2_current.txt`
  CURRENT3=`cat ./info-doc/8.3_current.txt`
  echo "$CURRENT1$CURRENT2$CURRENT3" >> ./$RUST_DOC_TCZ.info

  cat $RESOURCE_FILES_DIRECTORY/info-doc/1_title-latest.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/2_description.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/3_version.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/4_author-copying-policy.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/5_size.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/6_extension_by-comments.txt\
    $RESOURCE_FILES_DIRECTORY/info-doc/7_change-log.txt\
    > ./rust-i586-doc.tcz.info
  echo "$CURRENT1$CURRENT2$CURRENT3" >> ./rust-i586-doc.tcz.info
fi

cp $RESOURCE_FILES_DIRECTORY/rust.tcz.dep ./$RUST_TCZ.dep
echo $RUST_TCZ > ./$RUST_DOC_TCZ.dep
echo "rust-i586.tcz" > rust-i586-doc.tcz.dep

ln ./$RUST_TCZ.dep ./rust-i586.tcz.dep
md5sum ./rust-i586.tcz > ./rust-i586.tcz.md5.txt
sha1sum ./rust-i586.tcz > ./rust-i586.tcz.sha1.txt
sha256sum ./rust-i586.tcz > ./rust-i586.tcz.sha256.txt
sha512sum ./rust-i586.tcz > ./rust-i586.tcz.sha512.txt

md5sum ./rust-i586.tcz > ./rust-i586-doc.tcz.md5.txt
sha1sum ./rust-i586.tcz > ./rust-i586.tcz.sha1.txt
sha256sum ./rust-i586.tcz > ./rust-i586.tcz.sha256.txt
sha512sum ./rust-i586.tcz > ./rust-i586.tcz.sha512.txt

