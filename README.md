# cgenie.muffin.mix
A toolbox for getting cGENIE running on your favo[u]rite computer

This recipe kit is designed to reduce the challenges to running cGENIE on RedHat HPC facilities and UBUNTU workstations. 

To install cGENIE and its code dependencies on your machine, run:
chmod +x cGENIE.setup.sh
./cGENIE.setup.sh

Follow the interactive instructions. Note that the UBUNTU version is currently still in development (20230829), but could be pieced together by running the code interactively yourself. 

runmuffin-to-go.sh is designed to run like runmuffin.sh but on a SLURM based HPC facility. 
Upon download, run the code:
chmod +x runmuffin-to-go.sh

Then, runmuffin-to-go.sh will work exactly like runmuffin.sh and can be executed as:
./runmuffin-to-go.sh [base-config] [user-config directory] [model-years] [restart-if-applicable]

runmuffin-to-go-w-reciept.sh works the same way as runmuffin-to-go.sh but will send you email updates on the progress of your jobs. 
Again, before running for the first time, run the code:
chmod +x runmuffin-to-go-w-reciept.sh

Then you can excecute runmuffin-to-go-w-reciept.sh as:
./runmuffin-to-go-w-reciept.sh [email-address] [base-config] [user-config directory] [model-years] [restart-if-applicable]

Any issues - please contact Rich Stockey on r.g.stockey@soton.ac.uk

