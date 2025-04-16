#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-rust-i586                     #
###################################################################

##################################################################
# The tries to tce-load the generated tczs and then builds a 
# small test app.
#
# openssl-i586.tcz may not be required if you have already
# curl installed on your tinycore. This is why it is not in the
# rust-i586.tcz.dep.
##################################################################

# rust needs a C compiler and some glibc dependencies to build
# rust programs.
# The official .tcz files below work well
# on the ThinkPad 560z.
tce-load -wi gcc.tcz
tce-load -wi glibc_base-dev.tcz

# Built .tcz files.
tce-load -i openssl-i586.tcz
tce-load -i rust-i586.tcz
tce-load -i rust-i586-doc.tcz

rustc --version
cargo --version
TEST_APP_NAME=test-app-1
cargo new $TEST_APP_NAME
if cd $TEST_APP_NAME && cargo run; then
  echo "$TEST_APP_NAME has run successfully."
else
  echo "$TEST_APP_NAME has failed!"
  exit 1
fi

