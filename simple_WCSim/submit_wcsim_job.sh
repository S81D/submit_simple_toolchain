#!/bin/bash
# Job submission example for WCSim
# Author: Steven Doran

# usage: sh submit_grid_job.sh

USERNAME="<your_gpvm_name_here>"

export INPUT_PATH=/pnfs/annie/scratch/users/$USERNAME/                       # working directory, things get sent to the grid from here (INPUT)

OUTPUT_FOLDER=/pnfs/annie/scratch/users/$USERNAME/output/                    # path where files from the grid will be deposited (OUTPUT)
mkdir -p $OUTPUT_FOLDER     

echo ""
echo "submitting job..."
echo ""

# ------------------------------------------ #
# wrapper script to submit your grid job

#jobsub_submit \
#  --memory=2000MB \                                                // allocated memory - almost always you are fine with 2GB - sometimes you may need 4GB but test first
#  --expected-lifetime=6h \                                         // lifetime of the job
#  -G annie \                                                       // experiment - leave as is
#  --disk=10GB \                                                    // total size of all files - requested disk space needed
#  --resource-provides=usage_model=OFFSITE \                        // run to "offsite" node locations - can also use FNAL-only nodes but I have not rigorously tested this
#  --blacklist=Omaha,Swan,Wisconsin,RAL \                           // excluded sites - some places are not compatible with our container-in-a-container approach
#                                                                   // -f flags are the arguments for input files, which will need to be modified as needed. 
#  -f ${INPUT_PATH}/WCSim.tar.gz \                                  // WCSim tarball
#  -f ${INPUT_PATH}/wcsim_container.sh \                            // script that executes within the container
#  -d OUTPUT $OUTPUT_FOLDER \                                       // once job is done, files will be deposited here
#  file://${INPUT_PATH}/run_job.sh \                                // job script that will execute first on the grid node
#  jobname arg1 arg2 arg3                                           // any arguments to be passed to the grid scripts (run_job.sh and wcsim_container.sh)

# ----------------------------------------------- #

jobsub_submit --memory=2000MB --expected-lifetime=6h -G annie --disk=10GB --resource-provides=usage_model=OFFSITE --blacklist=Omaha,Swan,Wisconsin,RAL -f ${INPUT_PATH}/WCSim.tar.gz -f ${INPUT_PATH}/wcsim_container.sh -d OUTPUT $OUTPUT_FOLDER file://${INPUT_PATH}/run_job.sh jobname arg1 arg2 arg3           

# ----------------------------------------------- #

