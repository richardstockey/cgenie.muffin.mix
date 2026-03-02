#!/bin/bash
set -e

### =========================================================
### CGENIE TOOLCHAIN SETUP: GCC 6.4 + NETCDF STACK
### Clean, single-compiler build (NO module mixing)
### =========================================================

cd $HOME

# -------------------------------
# 1. Clean environment
# -------------------------------
module purge
unset CC CXX FC F77 F90 CPPFLAGS LDFLAGS LD_LIBRARY_PATH LIBRARY_PATH CPATH

# Create base install directory
mkdir -p $HOME/local

# -------------------------------
# 2. Build GCC 6.4.0 locally
# -------------------------------
cd $HOME
rm -rf gcc-6.4.0 gcc-build

wget https://ftp.gnu.org/gnu/gcc/gcc-6.4.0/gcc-6.4.0.tar.gz
tar -xzf gcc-6.4.0.tar.gz
cd gcc-6.4.0
./contrib/download_prerequisites

mkdir ../gcc-build
cd ../gcc-build

../gcc-6.4.0/configure \
  --prefix=$HOME/local/gcc-6.4.0 \
  --disable-multilib \
  --enable-languages=c,c++,fortran

make -j8
make install

# -------------------------------
# 3. Activate GCC 6 toolchain
# -------------------------------
export GCC_HOME=$HOME/local/gcc-6.4.0
export PATH=$GCC_HOME/bin:$PATH
export LD_LIBRARY_PATH=$GCC_HOME/lib64:$GCC_HOME/lib:$LD_LIBRARY_PATH

export CC=$GCC_HOME/bin/gcc
export CXX=$GCC_HOME/bin/g++
export FC=$GCC_HOME/bin/gfortran
export F77=$GCC_HOME/bin/gfortran
export F90=$GCC_HOME/bin/gfortran

# Confirm correct compiler
gcc --version
gfortran --version

# -------------------------------
# 4. Build NetCDF-C 4.6.1
# -------------------------------
cd $HOME
rm -rf netcdf-c-4.6.1 v4.6.1.tar.gz

wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.6.1.tar.gz
tar xzf v4.6.1.tar.gz
cd netcdf-c-4.6.1

./configure \
  --prefix=$HOME/local/netcdf-c-4.6.1 \
  --disable-netcdf-4 \
  --disable-dap \
  CC=$CC

make -j8
make install

# -------------------------------
# 5. Set NetCDF-C environment
# -------------------------------
export NETCDF_C_HOME=$HOME/local/netcdf-c-4.6.1
export CPPFLAGS="-I$NETCDF_C_HOME/include"
export LDFLAGS="-L$NETCDF_C_HOME/lib"
export LD_LIBRARY_PATH="$NETCDF_C_HOME/lib:$LD_LIBRARY_PATH"

# -------------------------------
# 6. Build NetCDF-Fortran 4.4.4
# -------------------------------
cd $HOME
rm -rf netcdf-fortran-4.4.4 v4.4.4.tar.gz

wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.4.4.tar.gz
tar xzf v4.4.4.tar.gz
cd netcdf-fortran-4.4.4

./configure \
  --prefix=$HOME/local/netcdf-fortran-4.4.4 \
  --enable-shared \
  CC=$CC \
  FC=$FC \
  CPPFLAGS="$CPPFLAGS" \
  LDFLAGS="$LDFLAGS"

make -j8
make install

# -------------------------------
# 7. Final environment setup
# -------------------------------
export NETCDF_FORTRAN_HOME=$HOME/local/netcdf-fortran-4.4.4

export CPPFLAGS="-I$NETCDF_C_HOME/include -I$NETCDF_FORTRAN_HOME/include"
export LDFLAGS="-L$NETCDF_C_HOME/lib -L$NETCDF_FORTRAN_HOME/lib"
export LD_LIBRARY_PATH="$NETCDF_C_HOME/lib:$NETCDF_FORTRAN_HOME/lib:$GCC_HOME/lib64:$LD_LIBRARY_PATH"
export PATH="$NETCDF_C_HOME/bin:$NETCDF_FORTRAN_HOME/bin:$PATH"

echo "====================================================="
echo "GCC 6.4 + NetCDF stack built successfully."
echo "Ready to compile cGENIE with this environment."
echo "====================================================="
