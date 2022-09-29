#!/usr/bin/env sh

# Dependencies: curl

DEST_PREFIX=${DEST_PREFIX:="/opt"}
SCRATCH_DIR=${SCRATCH_DIR:="/tmp"}
exit=""

for dep in curl fzf
do
    if [ "$(which ${dep})" = "" ]
    then
        echo "${dep} missing"
        exit=return
    fi
done

$exit

inst_deps () {
    sudo apt install -y python3 python3-pip cmake libopenmpi* openmpi-*

    sudo apt-get install build-essential clang lld gdb bison flex perl qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5opengl5-dev libxml2-dev zlib1g-dev doxygen graphviz libwebkit2gtk-4.0-37 -y &
    python3 -m pip install --user --upgrade numpy pandas matplotlib scipy seaborn posix_ipc &
    wait
}

dl_tgz () {
    curl -s https://omnetpp.org/download/ | grep -o '"http.*.tgz"' | sed 's/"//g' > /tmp/omnetpp_archives
    curl -s https://omnetpp.org/download/old | grep -o '"http.*.tgz"' | sed 's/"//g' >> /tmp/omnetpp_archives
    tgz_link=$(cat /tmp/omnetpp_archives | fzf)
    
    cd ${SCRATCH_DIR}
    [ -f $(basename ${tgz_link}) ] || wget ${tgz_link}
}

extract () {
    cd /tmp
    tar -xzf "${SCRATCH_DIR}/$(basename ${tgz_link})"
    omnet_root="$(find ${PWD} -maxdepth 1 -type d -name 'omnet*' | head -n 1)"
    sudo mv ${omnet_root} ${DEST_PREFIX}
    omnet_root="${DEST_PREFIX}/$(basename ${omnet_root})"
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

rm -i ${SCRATCH_DIR}/$(basename ${tgz_link})
echo "Done!"