# Build rust-x.y.z-i586.tcz and rust-x.y.z-i586-lite.tcz and their related .tcz.dep and .tcz.info

ARCHITECTURE=x86
OPENSSL_VERSION=3.2.0
RUST_VERSION=1.92.0
TCL_VERSION=16.x

all: build publish

build:
	tools/build.sh ${ARCHITECTURE} ${OPENSSL_VERSION} ${RUST_VERSION} ${TCL_VERSION}

publish:
	tools/publish.sh ${RUST_VERSION} ${OPENSSL_VERSION}

