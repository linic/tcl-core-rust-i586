#!/bin/sh

###################################################################
# Copyright (C) 2026  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-rust-i586                     #
###################################################################

##################################################################
# The script checks all dependencies are available.
# It builds the docker image which builds the custom
# rust-x.y.z-i586.tcz and rust-x.y.z-i586-doc.tcz and their
# related .tcz.dep and .tcz.info
# in a release/$RUST_VERSION directory (for example release/1.85.0/).
##################################################################

usage()
{
  USAGE="OPENSSL_VERSION RUST_VERSION are required for example: ./build-locally.sh 3.2.0 1.94.0"
  echo $USAGE
  return 2
}

get_openssl()
{
  BASE_URL="https://github.com/linic/openssl-i586/releases/download/$OPENSSL_VERSION"
  OPENSSL_LIB_SUFFIX=`echo $OPENSSL_VERSION | cut -d '.' -f 1`
  LIBCRYPTO_SO="libcrypto.so.$OPENSSL_LIB_SUFFIX"
  LIBSSL_SO="libssl.so.$OPENSSL_LIB_SUFFIX"
  OPENSSL_DEPENDENCY_PATH="$HOME_TC/openssl-$OPENSSL_VERSION-i586-release"
  mkdir -pv "$OPENSSL_DEPENDENCY_PATH"
  cd "$OPENSSL_DEPENDENCY_PATH"
  if [ ! -f "$LIBCRYPTO_SO" ]; then
    curl --remote-name "$BASE_URL/$LIBCRYPTO_SO"
    curl --remote-name "$BASE_URL/$LIBCRYPTO_SO.sha512.txt"
    sha512sum -c "$LIBCRYPTO_SO"
    if [ $? != 0 ]; then
      echo "Download of $LIBCRYPTO_SO failed!"
      return 30
    fi
  fi
  if [ ! -f "$LIBSSL_SO" ]; then
    curl --remote-name "$BASE_URL/$LIBSSL_SO"
    curl --remote-name "$BASE_URL/$LIBSSL_SO.sha512.txt"
    sha512sum -c "$LIBSSL_SO"
    if [ $? != 0 ]; then
      echo "Download of $LIBSSL_SO failed!"
      return 31
    fi
  fi
  return 0
}

get_rust()
{
  BASE_URL="https://github.com/linic/rust-i586/releases/download/$RUST_VERSION"
  RUST_TOOLCHAIN_NAME="rust-$RUST_VERSION-i586-unknown-linux-gnu"
  RUST_TOOLCHAIN_TAR="$RUST_TOOLCHAIN_NAME.tar.gz"
  RUST_DEPENDENCY_PATH="$HOME_TC/rust-$RUST_VERSION-i586-release"
  mkdir -pv "$RUST_DEPENDENCY_PATH"
  cd "$RUST_DEPENDENCY_PATH"
  if [ ! -f $RUST_TOOLCHAIN_TAR ]; then
    curl --remote-name "$BASE_URL/$RUST_TOOLCHAIN_TAR"
    curl --remote-name "$BASE_URL/$RUST_TOOLCHAIN_TAR.sha512.txt"
    sha512sum -c "$RUST_TOOLCHAIN_TAR.sha512.txt"
    if [ $? != 0 ]; then
      echo "Download of $RUST_TOOLCHAIN_TAR failed!"
      return 40
    fi
  fi
  return 0
}

compile_openssl_tcz()
{
  OPENSSL_TCZ="openssl-$OPENSSL_VERSION-i586.tcz"
  OPENSSL_TCZ_COMPILE_DIR="$HOME_TC/openssl-$OPENSSL_VERSION-i586_tcz"
  OPENSSL_TCZ_LIB_PATH="$OPENSSL_TCZ_COMPILE_DIR/usr/lib"
  OPENSSL_TCZ_RELEASE_PATH="$OPENSSL_TCZ_COMPILE_DIR-release"
  mkdir -pv "$OPENSSL_TCZ_LIB_PATH"
  cp "$OPENSSL_DEPENDENCY_PATH/$LIBCRYPTO_SO" "$OPENSSL_TCZ_LIB_PATH/"
  cp "$OPENSSL_DEPENDENCY_PATH/$LIBSSL_SO" "$OPENSSL_TCZ_LIB_PATH/"
  mkdir -pv "$OPENSSL_TCZ_RELEASE_PATH"
  cp -rv "$GIT_REPO_DIR/info-openssl" "$OPENSSL_TCZ_COMPILE_DIR"
  cp -rv "$GIT_REPO_DIR/tools/generate-openssl-tcz.sh" "$OPENSSL_TCZ_COMPILE_DIR"
  cd "$OPENSSL_TCZ_COMPILE_DIR"
  ./generate-openssl-tcz.sh "$OPENSSL_VERSION"
  return $?
}

compile_rust_tcz()
{
  RUST_RELEASE_NAME="rust-$RUST_VERSION-i586"
  RUST_TCZ="$RUST_RELEASE_NAME.tcz"
  RUST_DOC_TCZ="$RUST_RELEASE_NAME-doc.tcz"
  RUST_TCZ_COMPILE_DIR="$HOME_TC/rust-$RUST_VERSION-i586_tcz"
  RUST_TOOLCHAIN_TAR_PATH="$RUST_DEPENDENCY_PATH/$RUST_TOOLCHAIN_TAR"
  RUST_TCZ_RELEASE_PATH="$RUST_TCZ_COMPILE_DIR-release"
  mkdir -pv "$RUST_TCZ_COMPILE_DIR"
  mkdir -pv "$RUST_TCZ_RELEASE_PATH"
  cp -rv "$GIT_REPO_DIR/info" "$RUST_TCZ_COMPILE_DIR"
  cp -rv "$GIT_REPO_DIR/tools/generate-rust-tczs.sh" "$RUST_TCZ_COMPILE_DIR"
  cp -rv "$GIT_REPO_DIR/tools/generate-tcz-companions.sh" "$RUST_TCZ_COMPILE_DIR"
  cd "$RUST_TCZ_COMPILE_DIR"
  ./generate-rust-tczs.sh "$RUST_VERSION"
  RESULT=$?
  if [ $RESULT != 0 ]; then
    return $RESULT
  fi
  ./generate-tcz-companions.sh "$RUST_VERSION"
  return $?
}

clone()
{
  sudo mkdir -pv "$GIT_REPO_DIR"
  sudo chown tc:staff "$GIT_REPO_DIR"
  RESULT=$?
  if [ $RESULT != 0 ]; then
    echo "Failed to create $GIT_REPO_DIR"
    return $RESULT
  fi
  cd "$GIT_REPO_DIR"
  git clone git@github.com:linic/tcl-core-rust-i586.git .
  RESULT=$?
  if [ $RESULT != 0 ]; then
    echo "Failed git clone using ssh $GIT_REPO_DIR. Trying https..."
    git clone https://github.com/linic/tcl-core-rust-i586.git .
    RESULT=$?
    if [ $RESULT != 0 ]; then
      echo "Failed git clone using https $GIT_REPO_DIR. No more tries."
    fi
  fi

  return $RESULT
}

ensure_git_repo()
{
  if [ ! -d "$GIT_REPO_DIR" ]; then
    echo "$GIT_REPO_DIR does not exist."
    echo "mkdir and clone ? [y/N]"
    read -r ANSWER

    case $ANSWER in
      [yY])
        clone && return $? ;;
      *)
        return 3 ;;
    esac
  fi
  return 0
}

main()
{
  if [ ! $# -eq 2 ]; then
    usage
    exit $?
  fi

  OPENSSL_VERSION="$1"
  RUST_VERSION="$2"
  HOME_TC="/home/tc"
  GIT_REPO_DIR="/home/code/tcl-core-rust-i586"
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

  ensure_git_repo
  RESULT=$?
  if [ $RESULT != 0 ]; then
    exit $RESULT
  fi

  "$SCRIPT_DIR/tce-load-build-requirements.sh"
  RESULT=$?
  if [ $RESULT != 0 ]; then
    echo "Failed to load build requirements."
    exit $RESULT
  fi

  get_openssl
  RESULT=$?
  if [ $RESULT != 0 ]; then
    exit $RESULT
  fi

  get_rust
  RESULT=$?
  if [ $RESULT != 0 ]; then
    exit $RESULT
  fi

  compile_openssl_tcz
  RESULT=$?
  if [ $RESULT != 0 ]; then
    exit $RESULT
  fi

  compile_rust_tcz
  RESULT=$?
  if [ $RESULT != 0 ]; then
    exit $RESULT
  fi

  return 0
}

main "$@"
