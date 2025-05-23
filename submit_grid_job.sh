#!/bin/bash
# Job submission example for the PrintDQ toolchain
# Author: Steven Doran

# usage: sh submit_grid_job.sh


USERNAME="<your_gpvm_name_here>"

export INPUT_PATH=/pnfs/annie/scratch/users/$USERNAME/                       # working directory, things get sent to the grid from here (INPUT)
export DATA_PATH=/pnfs/annie/persistent/processed/processed_EBV2/R4314/      # For the toolChain, ProcessedData path

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
#  -f ${DATA_PATH}/ProcessedData_PMTMRDLAPPD_R4314S0p2 \            // -f flags are the arguments for input files, which will need to be modified as needed. 
#  -f ${DATA_PATH}/ProcessedData_PMTMRDLAPPD_R4314S0p3 \            // attach as many as you need - can also write a short for loop attaching the necessary files
#  -f ${INPUT_PATH}/run_container_job.sh \                          // script that executes within the container
#  -f ${INPUT_PATH}/MyToolAnalysis_grid.tar.gz \                    // ToolAnalysis tarball
#  -d OUTPUT $OUTPUT_FOLDER \                                       // once job is done, files will be deposited here
#  file://${INPUT_PATH}/grid_job.sh \                               // job script that will execute first on the grid node
#  jobname arg1 arg2 arg3                                           // arguments to be passed to the grid script

# ----------------------------------------------- #

jobsub_submit --memory=2000MB --expected-lifetime=6h -G annie --disk=10GB --resource-provides=usage_model=OFFSITE --blacklist=Omaha,Swan,Wisconsin,RAL -f ${DATA_PATH}/ProcessedData_PMTMRDLAPPD_R4314S0p2 -f ${DATA_PATH}/ProcessedData_PMTMRDLAPPD_R4314S0p3 -f ${INPUT_PATH}/run_container_job.sh -f ${INPUT_PATH}/MyToolAnalysis_grid.tar.gz -d OUTPUT $OUTPUT_FOLDER file://${INPUT_PATH}/grid_job.sh jobname arg1 arg2 arg3           

# ----------------------------------------------- #              


# If you have to attach many files for your toolchain, you can add the following for loop before the wrapper script:

# PART_FILES=""
# for FILE in ${PROCESSED_FILES_PATH}ProcessedData*; do
#    PART_FILES="$PART_FILES -f $FILE"
# done

# add $PART_FILES right after the blacklist arg, replacing the "-f ${DATA_PATH}/ProcessedData_PMTMRDLAPPD_R4314S0p2"
# example: "--blacklist=Omaha,Swan,Wisconsin,RAL $PART_FILES -f ${INPUT_PATH}/run_container_job.sh"


