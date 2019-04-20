FROM nvidia/cuda:9.1-devel-ubuntu16.04

MAINTAINER elonliu

RUN apt-get update -qq && \
  apt-get install -y \
  git bzip2 wget sox unzip\
  g++ make python python3 \
  zlib1g-dev automake autoconf libtool subversion \
  libatlas-base-dev

WORKDIR /usr/local/
# Use the newest kaldi version
RUN git clone https://github.com/kaldi-asr/kaldi.git

ENV CPU_CORE 6
WORKDIR /usr/local/kaldi/tools
RUN extras/install_mkl.sh && extras/check_dependencies.sh
RUN make -j $CPU_CORE

WORKDIR /usr/local/kaldi/src
RUN ./configure && make depend -j $CPU_CORE && make -j $CPU_CORE
