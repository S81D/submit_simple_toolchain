#!/bin/bash 
# James Minock 
# Author: Steven Doran

# execute WCSim events on the grid

# job script that runs within the container and executes your toolchain

ARG1=$1     # example arguments passed down
ARG2=$2     # use these in the script as needed

# ------------------------------------------
# generate additional logfile for de-bugging / recording WCSim event action verbose
touch /srv/logfile_${ARG1}_${ARG2}.txt         
echo "pwd:" >> /srv/logfile_${ARG1}_${ARG2}.txt
pwd >> /srv/logfile_${ARG1}_${ARG2}.txt
echo "" >> /srv/logfile_${ARG1}_${ARG2}.txt

echo "sourcing script:" >> /srv/logfile_${ARG1}_${ARG2}.txt
echo "" >> /srv/logfile_${ARG1}_${ARG2}.txt
# ------------------------------------------

# source setup script (YOU NEED TO ADD THIS TO YOUR BUILD DIRECTORY IF YOU HAVENT ALREADY IN ORDER TO RUN WCSIM ON THE GRID)
source sourceme >> /srv/logfile_${ARG1}_${ARG2}.txt
chmod +x WCSim     # makes it executable

# ------------------------------------------
echo "" >> /srv/logfile_${ARG1}_${ARG2}.txt
echo "running WCSim..." >> /srv/logfile_${PART_NAME}.txt
# ------------------------------------------


# Run WCSim, and output verbose to log file 
./WCSim WCSim.mac >> /srv/logfile_${ARG1}_${ARG2}.txt


# ------------------------------------------
echo "" >> /srv/logfile_${ARG1}_${ARG2}.txt
echo "-----------------------------------------" >> /srv/logfile_${ARG1}_${ARG2}.txt
echo "Finished!" >> /srv/logfile_${ARG1}_${ARG2}.txt

echo "" >> /srv/logfile_${ARG1}_${ARG2}.txt
echo "WCSim directory contents:" >> /srv/logfile_${ARG1}_${ARG2}.txt
ls -lrth >> /srv/logfile_${ARG1}_${ARG2}.txt
echo "" >> /srv/logfile_${ARG1}_${ARG2}.txt
# ------------------------------------------


# Lastly, copy any produced files to /srv for extraction
#       - default wcsim root file name will always be wcsim_0.root, unless if you are generating > 10k events, then it will split it into 10k chunks (wcsim_1.root, wcsim_2.root, etc...)
#       - same goes for the lappd files
#       - if you are generating MANY events (spread across multiple jobs) it is useful to rename the root files based on arguments passed through or the job id so that you dont get the same copy of wcsim_0.root in your output directory

# if you just want a simple example: (one root file, one job)
#cp wcsim_0.root /srv/wcsim_0.root                   
#cp wcsim_lappd_0.root /srv/wcsim_lappd_0.root

# for multiple jobs, you can rename them:
cp wcsim_0.root /srv/wcsim_${ARG1}_${ARG2}.root                   
cp wcsim_lappd_0.root /srv/wcsim_lappd_${ARG1}_${ARG2}.root
# add other root files if you are generating > 10k events


# make sure any output files you want to keep are put in /srv or any subdirectory of /srv 

### END ###
