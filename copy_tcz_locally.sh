#!/bin/bash
# NOTE: you may need to call this script with sudo unless you are root.
id=$(docker create linichotmailca/tcl-core-rust-i586:latest)
docker cp $id:/home/tc/$latest_rust_tcz .
docker rm -v $id
