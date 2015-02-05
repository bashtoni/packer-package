#!/bin/bash -e

if [ ! -n "$1" ]; then
  echo "Please specify the version of Packer to build, eg 0.7.5"
  exit 2
fi
if ! [[ $(type -P "fpm") ]]; then
  echo "You need fpm installed - gem install fpm should do the trick"
  exit 3
fi

FILE="packer_${1}_linux_amd64.zip"
WORKDIR="workdir$$"
PACKAGE_TYPE=${2:-rpm}

mkdir -p pkg
if [ ! -e ${FILE} ]; then
  mkdir -p ${WORKDIR}
  wget https://dl.bintray.com/mitchellh/packer/${FILE}
fi
unzip $FILE -d $WORKDIR
fpm -p pkg --name packer --version $1 --iteration 1 -a x86_64 -t $PACKAGE_TYPE -s dir $WORKDIR/=/usr/bin
rm -rf $WORKDIR
rm $FILE
exit 0
