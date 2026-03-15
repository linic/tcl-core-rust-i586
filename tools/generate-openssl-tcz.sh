
#!/bin/sh

###################################################################
# Copyright (C) 2026  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-rust-i586                     #
###################################################################

##################################################################
# The script generates the openssl-x.y.z-i586.tcz from
# libssl.so.x and libcrypto.so.x.
##################################################################

HOME_TC="/home/tc"

usage()
{
  echo "OPENSSL_VERSION is required."
  echo "For example:"
  echo "./generate-openssl-tcz.sh 3.0.0"
}

compile()
{
  echo "Compiling openssl-x.y.z-i586.tcz ..."
  if mksquashfs "$OPENSSL_SQUASHFS_SOURCE_PATH" "$OPENSSL_VERSION_TCZ_PATH"; then
    echo "./openssl-$OPENSSL_VERSION-i586.tcz generated successfully."
    if ! grep -q "$OPENSSL_VERSION" $OPENSSL_INFO_FILES_PATH/1_title.txt; then
      echo "Title:          openssl-$OPENSSL_VERSION-i586-openssl.tcz" > $OPENSSL_INFO_FILES_PATH/1_title.txt
      echo "Version:        $OPENSSL_VERSION" > $OPENSSL_INFO_FILES_PATH/3_version.txt
      echo "Size:           `du -h ./$OPENSSL_VERSION_TCZ | cut -f1`" > $OPENSSL_INFO_FILES_PATH/5_size.txt
      echo "Extension_by:   linic@hotmail.ca" > $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "Tags:           cryptography tls ssl dev" >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "Comments:       Runs successfully on i686 CPUs and tested on the ThinkPad 560z." >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "                Required by rust toolchain." >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "                ----------" >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "                This extension contains:" >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "                  libssl.so.$OPENSSL_LIB_SUFFIX" >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "                  libcrypto.so.$OPENSSL_LIB_SUFFIX" >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "                from openssl - Apache 2.0 - https://www.openssl.org/" >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "                This is the minimum used by rust." >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "                Built by linic@hotmail.ca using the method described in these URLs: " >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "                  https://github.com/linic/tcl-core-rust-i586" >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "                  https://github.com/linic/$OPENSSL_LATEST_TCZ" >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      echo "                ----------" >> $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt
      PREVIOUS_VERSION=`cat $OPENSSL_INFO_FILES_PATH/8.3_current.txt`
      PREVIOUS_UPDATED=`cat $OPENSSL_INFO_FILES_PATH/8.2_current.txt`
      echo $OPENSSL_VERSION > $OPENSSL_INFO_FILES_PATH/8.3_current.txt
      echo "$TODAY updated $PREVIOUS_VERSION -> " > $OPENSSL_INFO_FILES_PATH/8.2_current.txt
      echo "                $PREVIOUS_UPDATED$PREVIOUS_VERSION" >> $OPENSSL_INFO_FILES_PATH/7_change-log.txt
    fi
  else
    echo "$OPENSSL_VERSION_TCZ - mksquashfs failed!"
    exit 30
  fi

  cat $OPENSSL_INFO_FILES_PATH/1_title.txt\
    $OPENSSL_INFO_FILES_PATH/2_description.txt\
    $OPENSSL_INFO_FILES_PATH/3_version.txt\
    $OPENSSL_INFO_FILES_PATH/4_author-copying-policy.txt\
    $OPENSSL_INFO_FILES_PATH/5_size.txt\
    $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt\
    $OPENSSL_INFO_FILES_PATH/7_change-log.txt\
    > "$OPENSSL_VERSION_TCZ_PATH.info"
  CURRENT1=`cat $OPENSSL_INFO_FILES_PATH/8.1_current.txt`
  CURRENT2=`cat $OPENSSL_INFO_FILES_PATH/8.2_current.txt`
  CURRENT3=`cat $OPENSSL_INFO_FILES_PATH/8.3_current.txt`
  echo "$CURRENT1$CURRENT2$CURRENT3" >> "$OPENSSL_VERSION_TCZ_PATH.info"

  cat $OPENSSL_INFO_FILES_PATH/1_title-latest.txt\
    $OPENSSL_INFO_FILES_PATH/2_description.txt\
    $OPENSSL_INFO_FILES_PATH/3_version.txt\
    $OPENSSL_INFO_FILES_PATH/4_author-copying-policy.txt\
    $OPENSSL_INFO_FILES_PATH/5_size.txt\
    $OPENSSL_INFO_FILES_PATH/6_extension_by-comments.txt\
    $OPENSSL_INFO_FILES_PATH/7_change-log.txt\
    > "$OPENSSL_VERSION_TCZ_PATH.info"
  echo "$CURRENT1$CURRENT2$CURRENT3" >> "$OPENSSL_VERSION_TCZ_PATH.info"

  md5sum "$OPENSSL_VERSION_TCZ" > "$OPENSSL_VERSION_TCZ.md5.txt"
  sha1sum "$OPENSSL_VERSION_TCZ" > "$OPENSSL_VERSION_TCZ.sha1.txt"
  sha256sum "$OPENSSL_VERSION_TCZ" > "$OPENSSL_VERSION_TCZ.sha256.txt"
  sha512sum "$OPENSSL_VERSION_TCZ" > "$OPENSSL_VERSION_TCZ.sha512.txt"

  sed "s/$OPENSSL_VERSION_TCZ/$OPENSSL_LATEST_TCZ/g" "$OPENSSL_VERSION_TCZ.md5.txt" > "$OPENSSL_LATEST_TCZ.md5.txt"
  sed "s/$OPENSSL_VERSION_TCZ/$OPENSSL_LATEST_TCZ/g" "$OPENSSL_VERSION_TCZ.sha1.txt" > "$OPENSSL_LATEST_TCZ.sha1.txt"
  sed "s/$OPENSSL_VERSION_TCZ/$OPENSSL_LATEST_TCZ/g" "$OPENSSL_VERSION_TCZ.sha256.txt" > "$OPENSSL_LATEST_TCZ.sha256.txt"
  sed "s/$OPENSSL_VERSION_TCZ/$OPENSSL_LATEST_TCZ/g" "$OPENSSL_VERSION_TCZ.sha512.txt" > "$OPENSSL_LATEST_TCZ.sha512.txt"

  ln "$OPENSSL_VERSION_TCZ" "$OPENSSL_LATEST_TCZ_PATH"
  if [ $? != 0 ]; then
    echo "Failed to ln $OPENSSL_VERSION_TCZ $OPENSSL_LATEST_TCZ_PATH (non-fatal error)"
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
  OPENSSL_TCZ_COMPILE_DIR="$HOME_TC/openssl-$OPENSSL_VERSION-i586_tcz"
  OPENSSL_SQUASHFS_SOURCE_PATH="$OPENSSL_TCZ_COMPILE_DIR/squashfs-root"
  OPENSSL_INFO_FILES_PATH="$OPENSSL_TCZ_COMPILE_DIR/info-openssl"
  OPENSSL_VERSION_TCZ="openssl-$OPENSSL_VERSION-i586.tcz"
  OPENSSL_LATEST_TCZ="openssl-i586.tcz"
  OPENSSL_TCZ_RELEASE_PATH="$OPENSSL_TCZ_COMPILE_DIR-release"
  OPENSSL_VERSION_TCZ_PATH="$OPENSSL_TCZ_RELEASE_PATH/$OPENSSL_VERSION_TCZ"
  OPENSSL_LATEST_TCZ_PATH="$OPENSSL_TCZ_RELEASE_PATH/$OPENSSL_LATEST_TCZ"
  TODAY=`date "+%Y/%m/%d"`
  cd "$OPENSSL_COMPILE_DIR"
  compile
  RESULT=$?
  if [ $RESULT != 0 ]; then
    echo "Failed to compile $OPENSSL_VERSION_TCZ"
  fi

  exit $RESULT
}

main "$A"
