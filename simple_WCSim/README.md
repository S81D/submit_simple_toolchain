## Example grid submission scripts for WCSim

Example scripts on how to run WCSim on the FermiGrid, using James' container-in-a-container solution. 

Please refer to the global `submit_simple_toolchain` README for more information. 

## Setup

Please follow the `WCSim anniegpvm installation.pdf` instructions for building WCSim on the gpvms. You will need a working WCSim directory PRIOR to grid submission.

After you have successfully setup WCSim (and tested it to ensure you get back a root file after event generation), the next steps are as follows:
1. Copy the `sourceme` file to your build/ directory. This is needed for the grid.
2. Ensure your folder structure is as follows: 
    - WCSim/
        - WCSim/
        - build/
3. Ensure you have your WCSim.mac file set up with the appropriate event generation.
4. Remove any output files from previous event generation (any root files).
5. Tar your WCSim folder via: `tar -czvf WCSim.tar.gz -C /exp/annie/app/users/<USERNAME>/  WCSim`
    - where the preceeding path is the location of your WCSim folder, and WCSim is the name of the folder
6. Copy this tar file to your scratch area.

## Usage

- Edit scripts to suite your needs, including the username and the appropriate path locations
- Submit the job via: `sh submit_wcsim_job.sh`
- Returned in the output directory will be the log file + wcsim root files.
