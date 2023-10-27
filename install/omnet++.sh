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

choose_compiler () {
    available_compilers=""

    if command -v gcc >/dev/null 2>&1; then
        available_compilers="$available_compilers\ngcc"
    fi

    if command -v clang >/dev/null 2>&1; then
        available_compilers="$available_compilers\nclang"
    fi

    if command -v icx >/dev/null 2>&1; then
        available_compilers="$available_compilers\nicx"
    fi

    available_compilers=$(printf "$available_compilers" | sed '/^$/d')

    if [ -z "$available_compilers" ]; then
        echo "No compatible compilers found."
        exit 1
    fi

    printf "$available_compilers\n" | fzf --header "Select compiler" 
}

configure_make () {
    cd ${OMNET_ROOT}
    VER=$(git --no-pager tag --list | tac | fzf)
    git checkout ${VER}
    cp configure.user.dist configure.user
    . ./setenv

    # Set compiler to use
    case $(choose_compiler) in
        "gcc")
        compiler_cfg="CC=gcc CXX=g++ PREFER_CLANG=no PREFER_LLD=no"
        ;;
        "clang")
        compiler_cfg="CC=clang CXX=clang++ PREFER_CLANG=yes PREFER_LLD=yes"
        ;;
        "icx")
        compiler_cfg="CC=icx CXX=icpx PREFER_CLANG=no PREFER_LLD=no"
        ;;
        *)
        echo "?"
    esac

    # Compile with/without qtenv
    if [ -n "$DISPLAY" ]; then
        qtenv=yes
    else
        qtenv=no
    fi

    ./configure WITH_OSG=no $compiler_cfg $qtenv
    make -j$(getconf _NPROCESSORS_ONLN) all
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