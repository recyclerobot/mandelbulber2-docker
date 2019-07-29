# Use Debian stable (jessie)
FROM debian:jessie
ENV HOME /root
WORKDIR /root

# verify ubuntu version
# RUN cat /etc/lsb-release

# set noninteractive for installation
ARG DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list
RUN echo "deb-src http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list

# Install dependecies
RUN  apt-get update \
  && apt-get install -y wget tar

RUN apt-get install -y build-essential libqt5gui5 qt5-default libpng16-16 \
    libpng-dev qttools5-dev qttools5-dev-tools libgomp1 libgsl-dev \
    libsndfile1-dev qtmultimedia5-dev libqt5multimedia5-plugins liblzo2-2 \
    liblzo2-dev

# RUN \
#   apt-get update && apt-get install -y \
#   libncurses5-dev \
#   libglib2.0-dev \
#   libgeoip-dev \
#   libtokyocabinet-dev \
#   zlib1g-dev \
#   libncursesw5-dev \
#   libbz2-dev \
#   g++-6 \
#   libc6-i386 \
#   mesa-common-dev \
#   libgl1-mesa-dev

# RUN apt-get install -y \
#   libqt5gui5 \
#   qtbase5-dev \
#   qt5-qmake \
#   qtbase5-dev-tools \
#   qt5-style-plugins \
#   qt5-default \
#   libpng16-16 \
#   libpng-dev

# RUN apt-get install -y \
#   qttools5-dev \
#   qttools5-dev-tools \
#   libgomp1 \
#   libgsl-dev \
#   libsndfile1 \
#   libsndfile1-dev \
#   qtmultimedia5-dev \
#   libqt5multimedia5 \
#   libqt5multimedia5-plugins \
#   liblzo2-2 \
#   liblzo2-dev

# Download and unzip latest version
RUN wget https://github.com/buddhi1980/mandelbulber2/releases/download/2.18-1/mandelbulber2-2.18-1.tar.gz \
  && mkdir mandelbulber2 \
  && tar xvzf mandelbulber2-*.tar.gz --strip-components=1 -C mandelbulber2 \
  && chmod +x ./mandelbulber2/install

# Compile
RUN cd ./mandelbulber2/makefiles && qmake mandelbulber.pro && make all && cd ..

# Install
RUN apt-get install -y sudo
RUN cd /root/mandelbulber2 && echo y | ./install

# Test
RUN mandelbulber2 -h

# All done!
RUN echo "All Done!"


CMD ['bash']