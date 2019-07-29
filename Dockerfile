# Use Debian stable (jessie)
FROM debian:jessie
ENV HOME /root
WORKDIR /root

# set noninteractive for installation
ARG DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list
RUN echo "deb-src http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list

# Install dependecies
RUN  apt-get update \
  && apt-get install -y wget tar sudo

RUN apt-get install -y build-essential libqt5gui5 qt5-default libpng16-16 \
    libpng-dev qttools5-dev qttools5-dev-tools libgomp1 libgsl-dev \
    libsndfile1-dev qtmultimedia5-dev libqt5multimedia5-plugins liblzo2-2 \
    liblzo2-dev

# Download and unzip latest version
RUN wget https://github.com/buddhi1980/mandelbulber2/releases/download/2.18-1/mandelbulber2-2.18-1.tar.gz \
  && mkdir mandelbulber2 \
  && tar xvzf mandelbulber2-*.tar.gz --strip-components=1 -C mandelbulber2 \
  && chmod +x ./mandelbulber2/install

# Compile
RUN cd ./mandelbulber2/makefiles && qmake mandelbulber.pro && make all

# Install
RUN cd /root/mandelbulber2 && echo y | ./install

# Test
RUN mandelbulber2 -h

# All done!
RUN echo "All Done!"


CMD ['bash']