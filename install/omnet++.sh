#!/usr/bin/env sh

# Dependencies: curl

DEST_PREFIX=${DEST_PREFIX:="/opt"}
OMNET_ROOT=${OMNET_ROOT:=${DEST_PREFIX}/omnetpp}
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

    sudo apt-get install build-essential gdb bison flex perl qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5opengl5-dev libxml2-dev zlib1g-dev doxygen graphviz libwebkit2gtk-4.0-37 -y &
    python3 -m pip install --user --upgrade numpy pandas matplotlib scipy seaborn posix_ipc &
    wait
}

configure_make () {
    cd ${OMNET_ROOT}
    VER=$(git --no-pager tag --list | tac | fzf)
    git checkout ${VER}
    cp configure.user.dist configure.user
    . ./setenv
    ./configure WITH_OSG=no 
    make -j1 all
}

clone_omnet () {
    if [ ! -d ${OMNET_ROOT} ]
    then
        mkdir -p ${OMNET_ROOT} || (sudo mkdir -p ${OMNET_ROOT} && sudo chown ${USER} ${OMNET_ROOT})
        git clone https://github.com/omnetpp/omnetpp.git ${OMNET_ROOT}
    elif [ -f ${OMNET_ROOT}.git ]
    then
        cd ${OMNET_ROOT}
        git pull
        cd -
    fi
}

inst_deps
clone_omnet
configure_make


echo "Done!"