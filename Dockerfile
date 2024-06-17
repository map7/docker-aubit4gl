# Docker Image for Aubit4GL 1.6.1 (Open Source Informix 4GL compatible compiler)
#
# docker build -t map7/aubit4gl .
# docker run -t -i map7/aubit4gl /bin/bash
#
FROM debian:bullseye

ENV AUBITDIR "/aubit4glsrc"
ENV LD_LIBRARY_PATH "$LD_LIBRARY_PATH:$AUBITDIR/lib"
ENV PATH "$PATH:$AUBITDIR/bin"
ENV A4GL_UI "TUI"
ENV A4GL_SQLTYPE "pg8"
ENV A4GL_DBDATE "DMY4"

RUN apt-get update && apt-get install -y wget build-essential autoconf bison gdb libncurses5 postgresql bash libncurses5-dev libncursesw5-dev pkg-config flex libecpg-dev libglib2.0-dev doxygen splint expect texi2html libgmp3-dev perl-doc gawk libsigsegv2 libglade2-dev ruby less

# Install aubi4gl
RUN wget https://downloads.sourceforge.net/project/aubit4gl/Aubit%20Reasonably%20Stable%20Source/1.6.1/aubit4glsrc.1.6.1.tar.gz

RUN tar xf aubit4glsrc.1.6.1.tar.gz

WORKDIR $AUBITDIR
RUN ./configure
RUN make # NOTE: This has to be compiled in a single process
RUN make install

# For testing
WORKDIR $AUBITDIR/tools/test
RUN 4glpc hello.4gl -o hello
RUN fcompile form
RUN ln -s ../../etc/helpfile.hlp .

# Install gpcl6
RUN wget https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10031/ghostpdl-10.03.1.tar.gz
#RUN wget https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10012/ghostpdl-10.01.2.tar.gz

RUN tar xvf ghostpdl-10.03.1.tar.gz
WORKDIR ghostpdl-10.03.1
RUN ./configure
RUN make -j4
RUN make install

# Printer tools
RUN apt-get update && apt-get install -y cups-client curl iputils-ping


# Email tools
RUN apt-get update && apt-get install -y ruby-dev
RUN gem install mailfactory sqlite3
RUN gem install byebug

RUN rm -rf /var/lib/apt/lists/*
# # For debugging
# RUN apt-get update && apt-get install -y git
# RUN git clone https://github.com/MaxBarraclough/ECPG-Hello-World /ecpg-hello-world
# WORKDIR /ecpg-hello-world
# RUN ./build.sh

WORKDIR $AUBITDIR
