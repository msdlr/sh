#!/usr/bin/env sh

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --job-name=comp-mpi
#SBATCH --partition batch

rm -rf ~/ompi_${USER}

[ -d ~/src/open-mpi ] ||  git clone --recursive https://github.com/open-mpi/ompi ~/src/open-mpi
cd ~/src/open-mpi && git pull
# Última versión o la que se pase por param. a la función
[ ! -z $1 ] && git checkout $1
./autogen.pl &&
./configure --prefix=${HOME}/.local --with-slurm --disable-man-pages &&
make && 
make install &&
#tar cfv ${HOME}/ompi_${USER}.tar.gz -C /tmp ompi_${USER}
#tzip ${HOME}/ompi_${USER}.tar.gz -C /tmp ompi_${USER}
return
