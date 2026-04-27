#!/bin/sh

###################################################################
# Copyright (C) 2026  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-rust-i586                     #
###################################################################

##################################################################
# Generates openssl-x.y.z-i586.tcz from libssl.so.x and
# libcrypto.so.x.  All artifacts land in /home/tc/.
#
# The caller (Dockerfile or build-locally.sh) must stage the openssl
# shared libs at $OPENSSL_SQUASHFS_SOURCE_PATH/usr/lib/ and the
# info-openssl/ directory under $RESOURCE_FILES_DIRECTORY before
# invoking this script.
#
# Optional environment variables:
#   OPENSSL_SQUASHFS_SOURCE_PATH  directory containing usr/lib/libssl+libcrypto
#                                  default: /home/tc/openssl
#   RESOURCE_FILES_DIRECTORY       directory containing info-openssl/
#                                  default: . (= /home/tc after internal cd)
##################################################################

HOME_TC="/home/tc"

usage()
{
  echo "OPENSSL_VERSION is required."
  echo "For example:"
  echo "./generate-openssl-tcz.sh 3.0.0"
  return 2
}

compile()
{
  OPENSSL_SQUASHFS_SOURCE_PATH="${OPENSSL_SQUASHFS_SOURCE_PATH:-$HOME_TC/openssl}"
  RESOURCE_FILES_DIRECTORY="${RESOURCE_FILES_DIRECTORY:-.}"
  OPENSSL_VERSION_TCZ="openssl-$OPENSSL_VERSION-i586.tcz"
  OPENSSL_LATEST_TCZ="openssl-i586.tcz"
  TODAY=`date "+%Y/%m/%d"`

  echo "Compiling $OPENSSL_VERSION_TCZ ..."
  cd "$HOME_TC"
  if mksquashfs "$OPENSSL_SQUASHFS_SOURCE_PATH" "./$OPENSSL_VERSION_TCZ"; then
    echo "./$OPENSSL_VERSION_TCZ generated successfully."
    if ! grep -q "$OPENSSL_VERSION" "$RESOURCE_FILES_DIRECTORY/info-openssl/1_title.txt"; then
      echo "Title:          $OPENSSL_VERSION_TCZ" > "$RESOURCE_FILES_DIRECTORY/info-openssl/1_title.txt"
      echo "Version:        $OPENSSL_VERSION" > "$RESOURCE_FILES_DIRECTORY/info-openssl/3_version.txt"
      echo "Size:           `du -h ./$OPENSSL_VERSION_TCZ | cut -f1`" > "$RESOURCE_FILES_DIRECTORY/info-openssl/5_size.txt"
      echo "Extension_by:   linic@hotmail.ca" > "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "Tags:           cryptography tls ssl dev" >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "Comments:       Runs successfully on i686 CPUs and tested on the ThinkPad 560z." >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "                Required by rust toolchain." >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "                ----------" >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "                This extension contains:" >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "                  libssl.so.$OPENSSL_LIB_SUFFIX" >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "                  libcrypto.so.$OPENSSL_LIB_SUFFIX" >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "                from openssl - Apache 2.0 - https://www.openssl.org/" >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "                This is the minimum used by rust." >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "                Built by linic@hotmail.ca using the method described in these URLs: " >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "                  https://github.com/linic/tcl-core-rust-i586" >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "                  https://github.com/linic/openssl-i586" >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      echo "                ----------" >> "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt"
      PREVIOUS_VERSION=`cat "$RESOURCE_FILES_DIRECTORY/info-openssl/8.3_current.txt"`
      PREVIOUS_UPDATED=`cat "$RESOURCE_FILES_DIRECTORY/info-openssl/8.2_current.txt"`
      echo "$OPENSSL_VERSION" > "$RESOURCE_FILES_DIRECTORY/info-openssl/8.3_current.txt"
      echo "$TODAY updated $PREVIOUS_VERSION -> " > "$RESOURCE_FILES_DIRECTORY/info-openssl/8.2_current.txt"
      echo "                $PREVIOUS_UPDATED$PREVIOUS_VERSION" >> "$RESOURCE_FILES_DIRECTORY/info-openssl/7_change-log.txt"
    fi
  else
    echo "$OPENSSL_VERSION_TCZ - mksquashfs failed!"
    return 30
  fi

  cat "$RESOURCE_FILES_DIRECTORY/info-openssl/1_title.txt" \
    "$RESOURCE_FILES_DIRECTORY/info-openssl/2_description.txt" \
    "$RESOURCE_FILES_DIRECTORY/info-openssl/3_version.txt" \
    "$RESOURCE_FILES_DIRECTORY/info-openssl/4_author-copying-policy.txt" \
    "$RESOURCE_FILES_DIRECTORY/info-openssl/5_size.txt" \
    "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt" \
    "$RESOURCE_FILES_DIRECTORY/info-openssl/7_change-log.txt" \
    > "./$OPENSSL_VERSION_TCZ.info"
  CURRENT1=`cat "$RESOURCE_FILES_DIRECTORY/info-openssl/8.1_current.txt"`
  CURRENT2=`cat "$RESOURCE_FILES_DIRECTORY/info-openssl/8.2_current.txt"`
  CURRENT3=`cat "$RESOURCE_FILES_DIRECTORY/info-openssl/8.3_current.txt"`
  echo "$CURRENT1$CURRENT2$CURRENT3" >> "./$OPENSSL_VERSION_TCZ.info"

  cat "$RESOURCE_FILES_DIRECTORY/info-openssl/1_title-latest.txt" \
    "$RESOURCE_FILES_DIRECTORY/info-openssl/2_description.txt" \
    "$RESOURCE_FILES_DIRECTORY/info-openssl/3_version.txt" \
    "$RESOURCE_FILES_DIRECTORY/info-openssl/4_author-copying-policy.txt" \
    "$RESOURCE_FILES_DIRECTORY/info-openssl/5_size.txt" \
    "$RESOURCE_FILES_DIRECTORY/info-openssl/6_extension_by-comments.txt" \
    "$RESOURCE_FILES_DIRECTORY/info-openssl/7_change-log.txt" \
    > "./$OPENSSL_LATEST_TCZ.info"
  echo "$CURRENT1$CURRENT2$CURRENT3" >> "./$OPENSSL_LATEST_TCZ.info"

  md5sum "./$OPENSSL_VERSION_TCZ" > "./$OPENSSL_VERSION_TCZ.md5.txt"
  sha1sum "./$OPENSSL_VERSION_TCZ" > "./$OPENSSL_VERSION_TCZ.sha1.txt"
  sha256sum "./$OPENSSL_VERSION_TCZ" > "./$OPENSSL_VERSION_TCZ.sha256.txt"
  sha512sum "./$OPENSSL_VERSION_TCZ" > "./$OPENSSL_VERSION_TCZ.sha512.txt"

  sed "s/$OPENSSL_VERSION_TCZ/$OPENSSL_LATEST_TCZ/g" "./$OPENSSL_VERSION_TCZ.md5.txt" > "./$OPENSSL_LATEST_TCZ.md5.txt"
  sed "s/$OPENSSL_VERSION_TCZ/$OPENSSL_LATEST_TCZ/g" "./$OPENSSL_VERSION_TCZ.sha1.txt" > "./$OPENSSL_LATEST_TCZ.sha1.txt"
  sed "s/$OPENSSL_VERSION_TCZ/$OPENSSL_LATEST_TCZ/g" "./$OPENSSL_VERSION_TCZ.sha256.txt" > "./$OPENSSL_LATEST_TCZ.sha256.txt"
  sed "s/$OPENSSL_VERSION_TCZ/$OPENSSL_LATEST_TCZ/g" "./$OPENSSL_VERSION_TCZ.sha512.txt" > "./$OPENSSL_LATEST_TCZ.sha512.txt"

  ln "./$OPENSSL_VERSION_TCZ" "./$OPENSSL_LATEST_TCZ"
  if [ $? != 0 ]; then
    echo "Failed to ln $OPENSSL_VERSION_TCZ $OPENSSL_LATEST_TCZ (non-fatal error)"
  fi
}

main()
{
  if [ ! $# -eq 1 ]; then
    usage
    exit $?
  fi
  OPENSSL_VERSION=$1
  OPENSSL_LIB_SUFFIX=`echo $OPENSSL_VERSION | cut -d '.' -f 1`
  compile
  exit $?
}

main "$@"
