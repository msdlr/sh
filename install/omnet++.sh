#!/usr/bin/env sh

DEST_PREFIX="/opt"
SCRATCH_DIR="/tmp"

inst_deps () {
    sudo apt install -y python3 python3-pip libopenmpi* openmpi-*

    sudo apt-get install build-essential clang lld gdb bison flex perl qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5opengl5-dev libxml2-dev zlib1g-dev doxygen graphviz libwebkit2gtk-4.0-37 -y &
    python3 -m pip install --user --upgrade numpy pandas matplotlib scipy seaborn posix_ipc &
    wait
}

dl_tgz () {
    tgz_link=$(curl -s https://omnetpp.org/download/ | grep -o "http.*$(uname -m).tgz" | sed 's/".*$//g' | head -n 1)
    cd ${SCRATCH_DIR}
    [ -f $(basename ${tgz_link}) ] || wget ${tgz_link}
}

extract () {
    cd ${DEST_PREFIX}
    sudo tar -xzf "${SCRATCH_DIR}/$(basename ${tgz_link})"
    omnet_root="$(find ${DEST_PREFIX} -maxdepth 1 -type d -name 'omnet*')"
    sudo chown -R ${USER}:${USER} ${omnet_root}
}

configure () {
    cd ${omnet_root}
    . ./setenv
    sed -i "s/^WITH_OSG=.*/WITH_OSG=no/g" ${omnet_root}/configure.user
    ./configure
    make -j all
}

inst_deps
dl_tgz
extract
configure

echo "Done!"