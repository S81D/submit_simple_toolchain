#!/bin/bash 
# From James Minock 
# Author: Steven Doran

# script that executes on the grid node

cat <<EOF
condor   dir: $CONDOR_DIR_INPUT 
process   id: $PROCESS 
output   dir: $CONDOR_DIR_OUTPUT 
EOF

HOSTNAME=$(hostname -f) 
GRIDUSER="<USERNAME>"            # modify

# Argument passed through job submission
JOBNAME=$1
ARG1=$2         # example arguments (you can get rid of these if you don't need them -> adapt your script accordingly)
ARG2=$3

# --------------------------------------------------------------------------
# Create a dummy log file in the output directory to track progress / errors
DUMMY_OUTPUT_FILE=${CONDOR_DIR_OUTPUT}/${JOBNAME}_${ARG1}_${ARG2}_${JOBSUBJOBID}_dummy_output    # JOBSUBJOBID is a long multi-digit id # for your grid job
touch ${DUMMY_OUTPUT_FILE}

# keep track of run time
start_time=$(date +%s)   # start time in seconds 
echo "The job started at: $(date)" >> ${DUMMY_OUTPUT_FILE}
echo "" >> ${DUMMY_OUTPUT_FILE}
# --------------------------------------------------------------------------

# Copy datafiles from $CONDOR_INPUT onto worker node (/srv)
${JSB_TMP}/ifdh.sh cp -D $CONDOR_DIR_INPUT/WCSim.tar.gz .    # WCSim tarball

# un-tar WCSim
tar -xzf WCSim.tar.gz
rm WCSim.tar.gz

# ********** Modify to mimic your built WCSim directory *********** #
cd WCSim/build         # enter build directory

# --------------------------------------------------------------------------
# More log output for de-bugging
echo "current directory:" >> ${DUMMY_OUTPUT_FILE}
pwd >> ${DUMMY_OUTPUT_FILE}
echo "" >> ${DUMMY_OUTPUT_FILE}
echo "contents of directory:" >> ${DUMMY_OUTPUT_FILE}
ls -v >> ${DUMMY_OUTPUT_FILE}
echo "" >> ${DUMMY_OUTPUT_FILE}

echo "WCSim.mac contents:" >> ${DUMMY_OUTPUT_FILE}
echo "-------------------" >> ${DUMMY_OUTPUT_FILE}
cat WCSim.mac >> ${DUMMY_OUTPUT_FILE}
echo "" >> ${DUMMY_OUTPUT_FILE}
# --------------------------------------------------------------------------


# Depending on the analysis, choosing a new random seed everytime avoids simulating the same event topology

# generate random seed
echo "random seed:" >> ${DUMMY_OUTPUT_FILE}
let "a=$RANDOM"
b="/WCSim/random/seed"
echo "$b $a" >> macros/setRandomParameters.mac     # this macro controls the seeding

# --------------------------------------------------------------------------
# log random seed output for de-bugging
echo "$b $a" >> ${DUMMY_OUTPUT_FILE}
echo "" >> ${DUMMY_OUTPUT_FILE}
echo "macros:" >> ${DUMMY_OUTPUT_FILE}
ls macros/ >> ${DUMMY_OUTPUT_FILE}
echo "" >> ${DUMMY_OUTPUT_FILE}
echo "contents of setRandomParameters.mac" >> ${DUMMY_OUTPUT_FILE}
echo "" >> ${DUMMY_OUTPUT_FILE}
cat macros/setRandomParameters.mac >> ${DUMMY_OUTPUT_FILE}
echo "" >> ${DUMMY_OUTPUT_FILE}

# Tuning macro de-bugging
echo "tuning_parameters.mac:" >> ${DUMMY_OUTPUT_FILE}
echo "----------------------" >> ${DUMMY_OUTPUT_FILE}
cat macros/tuning_parameters.mac >> ${DUMMY_OUTPUT_FILE}
echo "" >> ${DUMMY_OUTPUT_FILE}
# --------------------------------------------------------------------------


# --------------------------------------------------------------------------
# this fixes a weird bug by making sure everything is bind mounted correctly - leave this in
echo "Make sure singularity is bind mounting correctly (ls /cvmfs/singularity)" >> ${DUMMY_OUTPUT_FILE}
ls /cvmfs/singularity.opensciencegrid.org >> ${DUMMY_OUTPUT_FILE}
echo "" >> ${DUMMY_OUTPUT_FILE}
# --------------------------------------------------------------------------


# Setup singularity container and execute the wcsim_container script (pass any args to the next script)
singularity exec -B/srv:/srv /cvmfs/singularity.opensciencegrid.org/anniesoft/wcsim\:latest/ $CONDOR_DIR_INPUT/wcsim_container.sh $ARG1 $ARG2


# ------ The script wcsim_container_job.sh will now run within singularity ------ #



# cleanup and move files to $CONDOR_OUTPUT after leaving singularity environment
echo "Moving the output files to CONDOR OUTPUT..." >> ${DUMMY_OUTPUT_FILE} 
${JSB_TMP}/ifdh.sh cp -D /srv/logfile* $CONDOR_DIR_OUTPUT                       # log files
${JSB_TMP}/ifdh.sh cp -D /srv/wcsim_${PART_NAME}.root $CONDOR_DIR_OUTPUT        # wcsim root file
${JSB_TMP}/ifdh.sh cp -D /srv/wcsim_lappd_${PART_NAME}.root $CONDOR_DIR_OUTPUT  # wcsim lappd root file


# --------------------------------------------------------------------------
# final de-bugging output
echo "" >> ${DUMMY_OUTPUT_FILE} 
echo "Input:" >> ${DUMMY_OUTPUT_FILE} 
ls $CONDOR_DIR_INPUT >> ${DUMMY_OUTPUT_FILE} 
echo "" >> ${DUMMY_OUTPUT_FILE} 
echo "Output:" >> ${DUMMY_OUTPUT_FILE} 
ls $CONDOR_DIR_OUTPUT >> ${DUMMY_OUTPUT_FILE} 

echo "" >> ${DUMMY_OUTPUT_FILE} 
echo "Cleaning up..." >> ${DUMMY_OUTPUT_FILE} 
echo "srv directory:" >> ${DUMMY_OUTPUT_FILE} 
ls -v /srv >> ${DUMMY_OUTPUT_FILE} 
# --------------------------------------------------------------------------

# make sure to clean up the files left on the worker node
rm -rf /srv/WCSim
rm /srv/*.txt
rm /srv/*.root

# --------------------------------------------------------------------------
# this can help inform which files are still leftover - adapt your script to clean up everything!
echo "" >> ${DUMMY_OUTPUT_FILE}
echo "remaining contents:" >> ${DUMMY_OUTPUT_FILE}
ls -v /srv >> ${DUMMY_OUTPUT_FILE}
# --------------------------------------------------------------------------

### END ###
