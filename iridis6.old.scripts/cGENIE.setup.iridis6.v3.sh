#!/bin/bash
### CGENIE LIBRARIES SETUP AND GENERAL INSTALL ###

cd $HOME

module purge

# install gcc 6.4.0 as not available by default on iridis6
wget https://ftp.gnu.org/gnu/gcc/gcc-6.4.0/gcc-6.4.0.tar.gz
tar -xvf gcc-6.4.0.tar.gz
cd gcc-6.4.0
./contrib/download_prerequisites
mkdir build && cd build
../configure --prefix=$HOME/gcc-6.4.0 --disable-multilib
make -j8
make install

export PATH=$HOME/gcc-6.4.0/bin:$PATH
export LD_LIBRARY_PATH=$HOME/gcc-6.4.0/lib64:$LD_LIBRARY_PATH

rm -rf netcdf-c-4.6.1 v4.6.1.tar.gz
wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.6.1.tar.gz
tar xzf v4.6.1.tar.gz
cd netcdf-c-4.6.1
make distclean  # just in case

# Patch ocprint.c to include missing headers (order matters)
sed -i '/#include <stdio.h>/a #include <unistd.h>' ncdump/ocprint.c
sed -i '/#include <stdio.h>/a #include <string.h>' ncdump/ocprint.c
sed -i '/#include <stdio.h>/a #include <ctype.h>' ncdump/ocprint.c


# Reconfigure with separate install prefix
./configure --prefix=$HOME --disable-netcdf-4
make -j4
make install

cd $HOME

# Set paths to NetCDF-C (must already be installed)
export NETCDF_HOME=$HOME/netcdf-c-4.6.1
export PATH="$NETCDF_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$NETCDF_HOME/lib:$LD_LIBRARY_PATH"
export LIBRARY_PATH="$NETCDF_HOME/lib:$LIBRARY_PATH"
export CPATH="$NETCDF_HOME/include:$CPATH"

export CPPFLAGS="-I$HOME/include"
export LDFLAGS="-L$HOME/lib"

# Clean any previous attempt
rm -rf netcdf-cxx-4.2 v4.2.tar.gz

# Download and unpack
wget https://downloads.unidata.ucar.edu/netcdf-cxx/4.2/netcdf-cxx-4.2.tar.gz
tar xzf netcdf-cxx-4.2.tar.gz
cd netcdf-cxx-4.2
make distclean  # just in case

# Configure with explicit install path
./configure --prefix=$HOME

# Build and install
make -j4
make install

cd $HOME

# Load compiler and environment
module purge
module load gcc/13.2.0

export NETCDF_HOME=$HOME/netcdf-c-4.6.1
export CPPFLAGS="-I$NETCDF_HOME/include"
export LDFLAGS="-L$NETCDF_HOME/lib"
export LD_LIBRARY_PATH="$NETCDF_HOME/lib:$LD_LIBRARY_PATH"
export FC=gfortran
export CC=gcc

# Clean up any previous builds
rm -rf netcdf-fortran-4.4.4 v4.4.4.tar.gz
wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.4.4.tar.gz
tar xzf v4.4.4.tar.gz
cd netcdf-fortran-4.4.4
make distclean  # just in case

# Configure with install prefix and NetCDF C path
./configure --prefix=$HOME

# Build and install
make -j4
make install

cd $HOME

# Set base paths for your NetCDF installations
export NETCDF_C_HOME=$HOME/netcdf-c-4.6.1
export NETCDF_CXX_HOME=$HOME/netcdf-cxx-4.2
export NETCDF_FORTRAN_HOME=$HOME/netcdf-fortran-4.4.4

# Include headers for compilation
export CPPFLAGS="-I$NETCDF_C_HOME/include -I$NETCDF_CXX_HOME/include -I$NETCDF_FORTRAN_HOME/include"

# Linker flags for libraries
export LDFLAGS="-L$NETCDF_C_HOME/lib -L$NETCDF_CXX_HOME/lib -L$NETCDF_FORTRAN_HOME/lib"

# Runtime library path for dynamic linking
export LD_LIBRARY_PATH="$NETCDF_C_HOME/lib:$NETCDF_CXX_HOME/lib:$NETCDF_FORTRAN_HOME/lib:$LD_LIBRARY_PATH"

# Optional: add binaries to PATH if you want to use netcdf tools directly
export PATH="$NETCDF_C_HOME/bin:$NETCDF_CXX_HOME/bin:$NETCDF_FORTRAN_HOME/bin:$PATH"
