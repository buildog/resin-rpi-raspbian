FROM debian:jessie

ENV TERM xterm

RUN echo "deb http://packages.matrix.one/matrix-creator/ ./" | sudo tee --append /etc/apt/sources.list
RUN apt-get update && sudo apt-get upgrade

RUN apt-get -q update \
	&& apt-get -qy install \
		curl \
		debootstrap \
		python \
		python-pip \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

RUN pip install awscli

# Install wget and curl
RUN apt-get update && apt-get install -y \
  wget \
  curl && rm -rf /var/lib/apt/lists/*

# Install other apt deps
RUN apt-get update && apt-get install -y \
  apt-utils \
  build-essential \
  clang \
  xserver-xorg-core \
  xserver-xorg-input-all \
  xserver-xorg-video-fbdev \
  xorg \
  libdbus-1-dev \
  libgtk2.0-dev \
  libnotify-dev \
  libgnome-keyring-dev \
  libgconf2-dev \
  libasound2-dev \
  libcap-dev \
  libcups2-dev \
  libxtst-dev \
  libxss1 \
  libnss3-dev \
  fluxbox \
  libsmbclient \
  libssh-4 \
  fbset \
  libexpat-dev && rm -rf /var/lib/apt/lists/*

# Set Xorg and FLUXBOX preferences
RUN mkdir ~/.fluxbox
RUN echo "xset s off\nxserver-command=X -s 0 dpms" > ~/.fluxbox/startup
RUN echo '#!/bin/sh\n\nexec /usr/bin/X -s 0 dpms -nocursor -nolisten tcp "$@"' > /etc/X11/xinit/xserverrc

# MATRIX
RUN apt-get -q -y install python build-essential python-dev python-pip
RUN apt-get install -y libzmq3-dev xc3sprog malos-eye matrix-creator-openocd wiringpi matrix-creator-init matrix-creator-malos cmake g++ git --force-yes;

#### NODE
RUN sudo apt-get install curl
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo bash -
RUN sudo apt-get install nodejs
RUN apt-get install make

## AUDIO (snowboy)
RUN apt-get install swig3.0 python-pyaudio python3-pyaudio sox
RUN pip install pyaudio
RUN apt-get install libatlas-base-dev
RUN sudo apt-get install alsa-base alsa-utils

RUN gpg --recv-keys --keyserver pgp.mit.edu 0x9165938D90FDDD2E

COPY . /usr/src/mkimage

WORKDIR /usr/src/mkimage

CMD ./build.sh
