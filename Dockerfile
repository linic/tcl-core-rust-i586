# Reusing images from existing repositories as resource images.
FROM linichotmailca/rust-i586:1.75.0 AS rust_resource
FROM linichotmailca/openssl-i586:1.1.1o AS openssl_resource
# Defining the image to use to create the final one.
FROM linichotmailca/tcl-core-x86:14.x-x86 AS final
# Defining arguments from which environment variables will be generated.
ARG RUST_VERSION=1.75.0-i586
ARG OPENSSL_LIB_SUFFIX=1.1
ARG OPENSSL_VERSION=1.1.1o
ARG TCL_VERSION=14.x-x86
# Defining all environment variables.
ENV RUST_TOOLCHAIN_NAME=rust-nightly-i586-unknown-linux-gnu
ENV RUST_TOOLCHAIN_TAR=$RUST_TOOLCHAIN_NAME.tar.gz
ENV RUST_TOOLCHAIN_TAR_PATH=/rust/build/dist/$RUST_TOOLCHAIN_TAR
ENV HOME_TC=/home/tc
ENV RUST_INSTALL_PATH=/home/tc/rust-$RUST_VERSION
ENV OPENSSL_SOURCE_PATH=/openssl-$OPENSSL_VERSION
ENV OPENSSL_SQUASHFS_SOURCE_PATH=$HOME_TC/openssl
ENV OPENSSL_LIB_PATH=$OPENSSL_SQUASHFS_SOURCE_PATH/usr/lib
# Copying data from resouce images.
COPY --from=openssl_resource $OPENSSL_SOURCE_PATH/libssl.so.$OPENSSL_LIB_SUFFIX $OPENSSL_LIB_PATH/libssl.so.3
COPY --from=openssl_resource $OPENSSL_SOURCE_PATH/libcrypto.so.$OPENSSL_LIB_SUFFIX $OPENSSL_LIB_PATH/libcrypto.so.3
# Generating and loading the .tcz file for openssl librairies.
WORKDIR $HOME_TC
RUN mksquashfs $OPENSSL_SQUASHFS_SOURCE_PATH openssl-$OPENSSL_VERSION.tcz
RUN tce-load -i openssl-$OPENSSL_VERSION.tcz
# Copying data from resouce images.
COPY --from=rust_resource $RUST_TOOLCHAIN_TAR_PATH $HOME_TC
# Installing rust to a custom path.
WORKDIR $HOME_TC
RUN tar -xvf $RUST_TOOLCHAIN_TAR
WORKDIR $RUST_TOOLCHAIN_NAME
RUN mkdir $RUST_INSTALL_PATH
RUN mkdir $RUST_INSTALL_PATH/etc
RUN sh ./install.sh --verbose --destdir=$RUST_INSTALL_PATH --sysconfdir=$RUST_INSTALL_PATH/etc
WORKDIR $RUST_COPY_PATH
# Generating, loading and testing the .tcz file.
RUN mksquashfs $RUST_INSTALL_PATH rust-$RUST_VERSION.tcz
RUN tce-load -i rust-$RUST_VERSION.tcz
RUN rustc --version
RUN cargo --version
ENV TEST_APP_NAME=test-app-1
RUN cargo new $TEST_APP_NAME
RUN cd $TEST_APP_NAME
RUN cargo run
# Then if you docker compose build you'll be able to docker exec -it into it and move around or
# docker cp files out of it.
ENTRYPOINT ["/bin/sh", "let i=0; while :; do sleep 1; let i++; echo $i; done"]

