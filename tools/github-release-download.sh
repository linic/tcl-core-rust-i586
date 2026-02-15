#!/bin/sh

#############################################################
# Copyright (C) 2026 linic@hotmail.ca under GPL-3.0 license.#
# https://github.com/linic/tcl-core-rust-i586               #
#############################################################

OPENSSL_VERSION="3.2.0"
ORGANIZATION="linic"
REPOSITORY="tcl-core-rust-i586"

usage()
{
  echo "./github-release-download [version|no-version] [version_number]"
  echo "example ./github-release-download no-version 1.93.0"
  return 1
}

download_no_version()
{
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-i586.tcz
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-i586.tcz.dep
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-i586.tcz.info
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-i586.tcz.md5.txt
  md5sum -c rust-i586.tcz.md5.txt
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-i586-doc.tcz
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-i586-doc.tcz.dep
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-i586-doc.tcz.info
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-i586-doc.tcz.md5.txt
  md5sum -c rust-i586-doc.tcz.md5.txt
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/openssl-i586.tcz
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/openssl-i586.tcz.dep
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/openssl-i586.tcz.info
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/openssl-i586.tcz.md5.txt
  md5sum -c openssl-i586.tcz.md5.txt
}

download_with_version()
{
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-$RUST_VERSION-i586.tcz
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-$RUST_VERSION-i586.tcz.dep
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-$RUST_VERSION-i586.tcz.info
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-$RUST_VERSION-i586.tcz.md5.txt
  md5sum -c rust-$RUST_VERSION-i586.tcz.md5.txt
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-$RUST_VERSION-i586-doc.tcz
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-$RUST_VERSION-i586-doc.tcz.dep
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-$RUST_VERSION-i586-doc.tcz.info
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/rust-$RUST_VERSION-i586-doc.tcz.md5.txt
  md5sum -c rust-$RUST_VERSION-i586-doc.tcz.md5.txt
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/openssl-$OPENSSL_VERSION-i586.tcz
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/openssl-$OPENSSL_VERSION-i586.tcz.dep
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/openssl-$OPENSSL_VERSION-i586.tcz.info
  wget -c https://github.com/$ORGANIZATION/$REPOSITORY/releases/download/$RUST_VERSION/openssl-$OPENSSL_VERSION-i586.tcz.md5.txt
  md5sum -c openssl-$OPENSSL_VERSION-i586.tcz.md5.txt
}

main()
{
  RUST_VERSION=$2
  if [ -z $RUST_VERSION ]; then
    usage
    exit $?
  fi
  case $1 in
    version)
      download_with_version
      exit $?
      ;;
    no-version)
      download_no_version
      exit $?
      ;;
    *)
      usage
      exit $?
      ;;
  esac
}

main "$@"
