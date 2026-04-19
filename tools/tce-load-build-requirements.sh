#!/bin/sh

###################################################################
# Copyright (C) 2026  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-rust-i586                     #
###################################################################

##################################################################
# Required .tcz extensions to run build-locally.sh on a booted
# Tiny Core Linux (no Docker). Unlike rust-i586's sibling script,
# this does not build rust from source — it repackages a prebuilt
# rust toolchain tar and prebuilt openssl shared libraries into
# .tcz extensions. That only needs mksquashfs, the usual hashers,
# and git/curl for fetching the assets.
##################################################################

tce-load -wi squashfs-tools.tcz coreutils.tcz git.tcz curl.tcz
