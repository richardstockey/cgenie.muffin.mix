#!/bin/bash
### CGENIE LIBRARIES SETUP AND GENERAL INSTALL ###

cd $HOME

echo "Hi there, this script assumes you are trying to get cgenie.muffin set up on IRIDIS 6."
echo "If you do not have a version of cgenie.muffin *already* cloned into your home directory, quit and start again."

module purge
module load gcc/13.2.0
export CFLAGS="-std=c11 -D_GNU_SOURCE"
export FC=gfortran
export CC=gcc

########################################
# PYTHON 2.7.18
########################################

cd $HOME

echo "Installing local Python 2.7.18..."

rm -rf Python-2.7.18 Python-2.7.18.tgz python2.7

wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
tar xzf Python-2.7.18.tgz
cd Python-2.7.18

./configure \
    --prefix=$HOME/python2.7

make -j4
make install

export PYTHON2_HOME=$HOME/python2.7
export PATH="$PYTHON2_HOME/bin:$PATH"

echo "Installed:"
python2.7 --version

cd $HOME

mkdir -p $HOME/bin

cat > $HOME/bin/python << 'EOF'
#!/bin/bash
exec $HOME/python2.7/bin/python2.7 "$@"
EOF

chmod +x $HOME/bin/python

export PATH="$HOME/bin:$PATH"

########################################
# Netcdf libraries
########################################

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
#export NETCDF_HOME=$HOME/netcdf-c-4.6.1
export NETCDF_HOME=$HOME
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

#export NETCDF_HOME=$HOME/netcdf-c-4.6.1
export NETCDF_HOME=$HOME
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

cp $HOME/cgenie.muffin.mix/user-iridis6.mak $HOME/cgenie.muffin/genie-main/user.mak
echo "We have also copied a new version of user.mak into cgenie.muffin/genie-main"

# Set base paths for your NetCDF installations
#export NETCDF_C_HOME=$HOME/netcdf-c-4.6.1
#export NETCDF_CXX_HOME=$HOME/netcdf-cxx-4.2
#export NETCDF_FORTRAN_HOME=$HOME/netcdf-fortran-4.4.4

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

# copy key functions over for running the model
cp $HOME/cgenie.muffin.mix/runmuffin-to-go-w-receipt.sh $HOME/cgenie.muffin/genie-main/runmuffin-to-go-w-receipt.sh
chmod +x $HOME/cgenie.muffin/genie-main/runmuffin-to-go-w-receipt.sh
cp $HOME/cgenie.muffin.mix/runmuffin-to-go.sh $HOME/cgenie.muffin/genie-main/runmuffin-to-go.sh
chmod +x $HOME/cgenie.muffin/genie-main/runmuffin-to-go.sh

echo "testing cGENIE.muffin..."
cd $HOME/cgenie.muffin/genie-main
make cleanall
make testbiogem
