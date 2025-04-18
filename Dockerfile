# To be able to read all the commands outputs as they get executed:
# sudo docker compose --progress-plain -f docker-compose.yml build
# Reusing images from existing repositories as resource images.
ARG ARCHITECTURE
ARG OPENSSL_LIB_SUFFIX
ARG OPENSSL_VERSION
ARG RUST_VERSION
ARG TCL_VERSION
FROM linichotmailca/rust-i586:$RUST_VERSION AS rust_resource
ARG ARCHITECTURE
ARG OPENSSL_LIB_SUFFIX
ARG OPENSSL_VERSION
ARG RUST_VERSION
ARG TCL_VERSION
FROM linichotmailca/openssl-i586:$OPENSSL_VERSION AS openssl_resource
# Defining the image to use to create the final one.
ARG ARCHITECTURE
ARG OPENSSL_LIB_SUFFIX
ARG OPENSSL_VERSION
ARG RUST_VERSION
ARG TCL_VERSION
FROM linichotmailca/tcl-core-x86:$TCL_VERSION-$ARCHITECTURE AS final
# Defining arguments from which environment variables will be generated.
ARG ARCHITECTURE
ARG OPENSSL_LIB_SUFFIX
ARG OPENSSL_VERSION
ARG RUST_VERSION
ARG TCL_VERSION
# Defining all environment variables.
ENV RUST_TOOLCHAIN_NAME=rust-nightly-i586-unknown-linux-gnu
ENV RUST_TOOLCHAIN_TAR=$RUST_TOOLCHAIN_NAME.tar.gz
ENV RUST_TOOLCHAIN_TAR_PATH=/home/tc/rust/build/dist/$RUST_TOOLCHAIN_TAR
ENV HOME_TC=/home/tc
ENV OPENSSL_SOURCE_PATH=/home/tc/openssl-$OPENSSL_VERSION
ENV OPENSSL_SQUASHFS_SOURCE_PATH=$HOME_TC/openssl
ENV OPENSSL_LIB_PATH=$OPENSSL_SQUASHFS_SOURCE_PATH/usr/lib
# Copying data from resouce images.
COPY --from=openssl_resource $OPENSSL_SOURCE_PATH/libssl.so.$OPENSSL_LIB_SUFFIX $OPENSSL_LIB_PATH/
COPY --from=openssl_resource $OPENSSL_SOURCE_PATH/libcrypto.so.$OPENSSL_LIB_SUFFIX $OPENSSL_LIB_PATH/
COPY --from=rust_resource $RUST_TOOLCHAIN_TAR_PATH $HOME_TC
# Generating and loading the .tcz files for openssl and rust.
WORKDIR $HOME_TC
COPY --chown=tc:staff rust.tcz.dep ./
COPY --chown=tc:staff ./info ./info
COPY --chown=tc:staff ./info-doc ./info-doc
COPY --chown=tc:staff ./info-openssl ./info-openssl
COPY --chown=tc:staff ./tools/generate-rust-tczs.sh ./tools/generate-rust-tczs.sh
RUN ./tools/generate-rust-tczs.sh $RUST_VERSION
COPY --chown=tc:staff ./tools/generate-tcz-companions.sh ./tools/generate-tcz-companions.sh
RUN ./tools/generate-tcz-companions.sh $RUST_VERSION
COPY --chown=tc:staff ./tools/generate-openssl-tcz.sh ./tools/generate-openssl-tcz.sh
RUN ./tools/generate-openssl-tcz.sh $OPENSSL_VERSION
COPY --chown=tc:staff ./tools/load-test.sh ./tools/load-test.sh
RUN ./tools/load-test.sh
# Then if you docker compose build you'll be able to docker exec -it into it and move around or
# docker cp files out of it.
COPY --chown=tc:staff tools/echo_sleep.sh /home/tc/tools/echo_sleep.sh
ENTRYPOINT ["/bin/sh", "/home/tc/tools/echo_sleep.sh"]

