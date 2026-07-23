#!/bin/bash -e
#
#####################################################################
### SCRIPT TO RUN ./RUNMUFFIN.SH ON IRIDIS6/X REDHAT HPC ############
#####################################################################

# ensure all key software is loaded
module purge
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

printf "#!/bin/sh

#SBATCH --nodes=1                # Number of nodes requested
#SBATCH --time=60:00:00
#SBATCH --mail-user=$1
#SBATCH --mail-type=BEGIN,END,FAIL

module load gcc/13.2.0

LD_LIBRARY_PATH=$HOME/lib
export LD_LIBRARY_PATH

cd ~/cgenie.muffin/genie-main

make cleanall &> ~/cgenie_log/cleanall_trash.txt;
./runmuffin.sh $2 $3 $4 $5 $6 &> ~/cgenie_log/cGEnIE.output_$(date '+%F_%H.%M').log
" > ~/cgenie.jobs/muffin-to-go.sbatch

sbatch ~/cgenie.jobs/muffin-to-go.sbatch
#rm ~/cgenie.jobs/muffin-to-go.sbatch
