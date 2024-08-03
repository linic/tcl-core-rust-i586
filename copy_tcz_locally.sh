#!/bin/bash
# NOTE: you may need to call this script with sudo unless you are root.
id=$(docker create linichotmailca/tcl-core-rust-i586:latest)
docker cp $id:/home/tc/rust-1.80.0-i586.tcz .
docker rm -v $id
