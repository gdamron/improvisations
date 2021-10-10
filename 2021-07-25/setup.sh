#!/bin/bash

apt-get update

if ! type git > /dev/null; then
  echo "installing git"
  apt-get -y install git
else
  echo "git is installed"
fi

if ! type bison > /dev/null; then
  echo "installing bison"
  apt-get -y install bison
else
  echo "bison is installed"
fi

if ! type flex > /dev/null; then
  echo "installing flex"
  apt-get -y install flex
else
  echo "flex is installed"
fi

if ! dpkg -s "alsa-base" > /dev/null; then
  echo "installing alsa-base"
  apt-get -y install alsa-base
 else
  echo "alsa-base is installed"
fi

if ! dpkg -s "libasound2-dev" > /dev/null; then
  echo "installing libasound2-dev"
  apt-get -y install libasound2-dev
 else
  echo "libasound2-dev is installed"
fi

if ! dpkg -s "libsndfile1-dev" > /dev/null; then
  echo "installing libsndfile1-dev"
  apt-get -y install libsndfile1-dev
 else
  echo "libsndfile1-dev is installed"
fi

if ! type chuck > /dev/null; then
  echo "installing chuck"
  mkdir git
  pushd git

  echo "cloning chuck"
  git clone https://github.com/ccrma/chuck
  
  pushd chuck/src

  echo "building chuck"
  make linux-alsa
  make install

  popd
  popd

  rm -rf git
else
  echo "chuck is installed"
fi

if [ ! "/usr/local/lib/chuck/WinFuncEnv.chug" ]; then
  echo "installing chugins"
  mkdir git
  pushd git

  echo "cloning chugins"
  git clone https://github.com/ccrma/chugins

  pushd chugins/WinFuncEnv
  make linux-alsa
  make install

  popd
  popd

  rm -rf git
else
  echo "chugins are installed"
fi

echo "done."
