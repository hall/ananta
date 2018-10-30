FROM i386/gcc:6.1 as build

COPY  . /usr/inferno
ENV PATH=/usr/inferno/arch/linux/386/bin/:$PATH
WORKDIR /usr/inferno

RUN MKFLAGS='SYSHOST=linux OBJTYPE=386 ROOT='$PWD; \
    mk $MKFLAGS clean && \
    mk $MKFLAGS mkdirs && \
    mk $MKFLAGS install

ENTRYPOINT ["emu"]

