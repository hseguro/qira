#!/bin/bash -e

# install system deps
if [ $(which apt-get) ]; then
  echo "installing deps for ubuntu"
  apt-get -y install git curl python python-dev python3-pip build-essential pkg-config zlib1g-dev libglib2.0-dev libpixman-1-dev
  pip3 install virtualenv 
 
else
  echo "*** You'll need to install Ubuntu or get a working build env for qemu and python yourself ***"
fi

# build qemu
if [[ "$(uname)" == 'Linux' ]]; then
  if [ $(tracers/qemu/qira-i386 > /dev/null; echo $?) == 1 ]; then
    echo "QIRA QEMU appears to run okay"
  else
    echo "building QEMU"
    cd tracers
    ./qemu_build.sh
    cd ../
  fi
else
  echo "QEMU user only works on Linux."
  echo "While the rest of QIRA will run, you cannot run binaries."
  echo "This is due to QEMU user forwarding the syscalls to the kernel."
  echo "See other backends in qira/tracers, PIN may work on Windows and OS X"
fi

echo "building python venv"
virtualenv venv
source venv/bin/activate
pip install --upgrade pip
pip install --upgrade -r requirements.txt

echo "running tests"
./run_tests.sh

echo "making systemwide symlink"
ln -sf $(pwd)/qira /usr/local/bin/qira

echo "***************************************"
echo "  Thanks for installing QIRA"
echo "  Check out README for more info"
echo "  Or just dive in with 'qira /bin/ls'"
echo "  And point Chrome to localhost:3002"
echo "    ~geohot"

