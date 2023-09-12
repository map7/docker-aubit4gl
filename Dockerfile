# Docker Image for Aubit4GL 1.6.1 (Open Source Informix 4GL compatible compiler)
#
# docker build -t map7/aubit4gl .
# docker run -t -i map7/aubit4gl /bin/bash
#
FROM debian:bookworm

ENV AUBITDIR "/aubit4glsrc"
ENV LD_LIBRARY_PATH "$LD_LIBRARY_PATH:$AUBITDIR/lib"
ENV PATH "$PATH:$AUBITDIR/bin"
ENV A4GL_UI "TUI"
ENV A4GL_SQLTYPE "pg8"
ENV A4GL_DBDATE "DMY4"

RUN apt-get update && apt-get install -y wget build-essential autoconf bison gdb valgrind curl libncurses5 postgresql bash libncurses5-dev libncursesw5-dev pkg-config flex iodbc unixodbc libecpg-dev libglib2.0-dev doxygen cvs splint expect texi2html libgmp3-dev perl-doc gawk libsigsegv2 libglade2-dev mg
RUN rm -rf /var/lib/apt/lists/*

RUN wget https://downloads.sourceforge.net/project/aubit4gl/Aubit%20Reasonably%20Stable%20Source/1.6.1/aubit4glsrc.1.6.1.tar.gz

RUN tar xf aubit4glsrc.1.6.1.tar.gz

WORKDIR $AUBITDIR
RUN ./configure
RUN make
RUN make install

WORKDIR $AUBITDIR/tools/test
RUN 4glpc hello.4gl -o hello
RUN fcompile form
RUN ln -s ../../etc/helpfile.hlp .

WORKDIR $AUBITDIR
