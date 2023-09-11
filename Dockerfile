FROM debian:buster

RUN wget https://downloads.sourceforge.net/project/aubit4gl/Aubit%20Reasonably%20Stable%20Source/1.6.1/aubit4glsrc.1.6.1.tar.gz

RUN tar xf aubit4glsrc.1.6.1.tar.gz

RUN apt-get update
