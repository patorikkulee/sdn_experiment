#!/bin/sh
# To install from source, see
# https://github.com/p4lang/tutorials/tree/master/vm-ubuntu-20.04
# Thanks prebuild packages to
# https://github.com/p4lang/p4c#ubuntu
sudo apt update

# root-bootstrap.sh
# some packages are not necessary when installing p4 with apt
sudo apt install -y autoconf automake bison build-essential \
  ca-certificates clang cmake cpp curl flex g++ git iproute2 \
  libboost-dev libboost-filesystem-dev libboost-graph-dev \
  libboost-iostreams-dev libboost-program-options-dev \
  libboost-system-dev libboost-test-dev libboost-thread-dev \
  libelf-dev libevent-dev libffi-dev libfl-dev libgc-dev \
  libgflags-dev libgmp-dev libjudy-dev libpcap-dev libpython3-dev \
  libreadline-dev libssl-dev libtool libtool-bin \
  linux-headers-$(uname -r) llvm make net-tools pkg-config \
  python3-dev python3-pip tcpdump unzip valgrind

sudo pip3 install scapy ipaddr pypcap psutil crcmod

# protobuf v3.6.1
# apt install python packages to /usr/lib/python3
# pip install python packages to /usr/local/lib/python3.x
# If build and install p4lang/PI from source, protobuf
# needs to be installed from pip
# If p4lang/PI is installed by apt, protobuf needs to be
# installed from apt, not pip
# It is because p4lang/PI adds files to protobuf,
# p4lang/PI/proto/google/rpc will be added, files from
# PI and protobuf need to be merged
# The following is for building PI from source
# sudo apt purge -y python3-protobuf
# sudo pip3 install protobuf==3.6.1

# user-bootstrap.sh
# intall the packages:
# - protobuf (apt)
# - grpc (apt)
# - p4lang-pi (apt)
# - p4lang-bmv2 (apt)
# - p4lang-p4c (apt)
# - mininet >= 2.3.0 (source)
# - p4lang-ptf (pip)

. /etc/os-release
echo "deb http://download.opensuse.org/repositories/home:/p4lang/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/home:p4lang.list
curl -L "http://download.opensuse.org/repositories/home:/p4lang/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -
sudo apt-get update

sudo apt install -y p4lang-pi p4lang-bmv2 p4lang-p4c

# mininet
# https://bugs.launchpad.net/ubuntu/+source/pyflakes/+bug/1951338
# Remove installed
sudo apt purge -y mininet
cd `mktemp -d`
git clone --depth=1 https://github.com/mininet/mininet.git
sed -i 's/$pf//' mininet/util/install.sh
sudo apt install -y --no-install-recommends pyflakes3
sudo ./mininet/util/install.sh -nw

# ptf
sudo apt install -y python3-testresources
sudo pip3 install ptf
