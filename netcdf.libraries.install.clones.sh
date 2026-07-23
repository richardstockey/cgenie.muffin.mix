#!/bin/bash
### CGENIE LIBRARIES SETUP AND GENERAL INSTALL ###
# This script installs the necessary NetCDF libraries for a specific clone of cgenie.muffin.
clone=$1
base_dir="/mainfs/scratch/$USER/cgenie.muffin-$clone"

if [ ! -d "$base_dir" ]; then
    echo "Directory $base_dir does not exist."
    exit 1
fi

cd "$base_dir" || exit 1

module load gcc/13.2.0
export CFLAGS="-std=c11 -D_GNU_SOURCE"
export FC=gfortran
export CC=gcc

# ensure python 2 setup correctly
export PYTHON2_HOME=$HOME/python2.7
export PATH="$PYTHON2_HOME/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Set base paths for your NetCDF installations
export NETCDF_C_HOME=$HOME
export NETCDF_CXX_HOME=$HOME
export NETCDF_FORTRAN_HOME=$HOME

# Include headers for compilation
export CPPFLAGS="-I$NETCDF_C_HOME/include -I$NETCDF_CXX_HOME/include -I$NETCDF_FORTRAN_HOME/include"

# Linker flags for libraries
export LDFLAGS="-L$NETCDF_C_HOME/lib -L$NETCDF_CXX_HOME/lib -L$NETCDF_FORTRAN_HOME/lib"

# Runtime library path for dynamic linking
export LD_LIBRARY_PATH="$NETCDF_C_HOME/lib:$NETCDF_CXX_HOME/lib:$NETCDF_FORTRAN_HOME/lib:$LD_LIBRARY_PATH"

# Optional: add binaries to PATH if you want to use netcdf tools directly
export PATH="$NETCDF_C_HOME/bin:$NETCDF_CXX_HOME/bin:$NETCDF_FORTRAN_HOME/bin:$PATH"

LD_LIBRARY_PATH=$HOME/lib
export LD_LIBRARY_PATH

### Install netcdf-4.6.1 ###
wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.6.1.tar.gz
tar xzf v4.6.1.tar.gz
cd netcdf-c-4.6.1
./configure --prefix=$base_dir --disable-netcdf-4 --disable-dap
make clean
make check
make install
cd ..

### Install netcdf-cxx-4.2 ###
wget https://downloads.unidata.ucar.edu/netcdf-cxx/4.2/netcdf-cxx-4.2.tar.gz
tar xzf netcdf-cxx-4.2.tar.gz
cd netcdf-cxx-4.2
export CPPFLAGS=-I$base_dir/include
export LDFLAGS=-L$base_dir/lib
./configure --prefix=$base_dir
make clean
make check
make install
cd ..

### Install netcdf-fortran-4.4.4 ###
wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.4.4.tar.gz
tar xzf v4.4.4.tar.gz
cd netcdf-fortran-4.4.4
export LD_LIBRARY_PATH=$base_dir/lib
./configure --prefix=$base_dir
make clean
make check
make install
cd ..

# Return to the original directory if needed
cd ..
