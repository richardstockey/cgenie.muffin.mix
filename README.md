# cgenie.muffin.mix
A toolbox for getting cGENIE running on your favo[u]rite computer

This recipe kit is designed to reduce the challenges to running cGENIE on RedHat HPC facilities and UBUNTU workstations. 

The whole folder can be downloaded to your $HOME directory with:

git clone https://github.com/richardstockey/cgenie.muffin.mix.git

To install cGENIE and its code dependencies on your machine, change to the cgenie.muffin.mix directory and run:

module load gcc/6.4.0; 
module load gnumake; 
LD_LIBRARY_PATH=/home/$USER/lib; 
export LD_LIBRARY_PATH; 
chmod +x cGENIE.setup.sh; 
./cGENIE.setup.sh

Follow the interactive instructions. Note that the UBUNTU version is currently still in development (20230829), but could be pieced together by running the code interactively yourself. 

runmuffin-to-go.sh is designed to run like runmuffin.sh but on a SLURM based HPC facility. 
Upon download, move the file to cgenie.muffin/genie-main (like the standard runmuffin.sh) by running:
mv cgenie.muffin.mix/runmuffin-to-go.sh cgenie.muffin/genie-main/runmuffin-to-go.sh

Go into your cgenie.muffin/genie-main directory, by running:
cd cgenie.muffin/genie-main

Then, run the code:
chmod +x runmuffin-to-go.sh

Then, runmuffin-to-go.sh will work exactly like runmuffin.sh and can be executed as:
./runmuffin-to-go.sh [base-config] [user-config directory] [model-years] [restart-if-applicable]

runmuffin-to-go-w-reciept.sh works the same way as runmuffin-to-go.sh but will send you email updates on the progress of your jobs. 
Again, before running for the first time, move the file to your cgenie.muffin/genie-main directory and run chmod +x to change your permissions. 

Then you can excecute runmuffin-to-go-w-reciept.sh as:
./runmuffin-to-go-w-reciept.sh [email-address] [base-config] [user-config directory] [model-years] [restart-if-applicable]

Any issues - please contact Rich Stockey on r.g.stockey@soton.ac.uk

If things are failing, you may be having issues with the gfortran (and other libraries that you're calling), and whether the versions used to build the legacy netcdf libraries that cGENIE requires are the same as the versions that you have loaded when running cGENIE. If in doubt, in every new session, run: 
module load gcc/6.4.0; 
module load gnumake; 
LD_LIBRARY_PATH=/home/$USER/lib; 
export LD_LIBRARY_PATH; 

This is especially important to do before running cGENIE.setup.sh!
