# centos-updated-ISO-builder

This project takes a number of input resources (e.g. the 'vanilla' Centos DVD ISO) and produces a new, custom ISO that contains an updated Centos installation for you.

## Pre-requisites

The 4GB CentOS DVD ISO, available at the following address:


## Build steps

1) Ensure that the CentOS DVD iso is present in working_directory.
2) Open the makeiso.sh file and update the reference to the vanilla ISO to match the filename of the CentOS DVD ISO (in step above)
3) Execute the makeiso.sh script. This will combine the ISO contents and download updates which are merged into the resultant ISO.
4) 
