#!/bin/bash

set -x

# Set global constants:
LINUX_ISO_PATH=./working_directory/mounted-centos-iso
TARGET_ISO_DIRECTORY=./isolinux/
#DOCKER_IMAGE_ID=b2ecbb8751df
DOCKER_OUTPUT_DIRECTORY=working_directory/docker_output

# Start Centos 7.5 docker container with several volumes and perform a reposync that grabs the updates, extras and centosplus repos.
sudo docker run --name reposync -td -v $(pwd)/docker_scripts:/docker_scripts -v $(pwd)/$DOCKER_OUTPUT_DIRECTORY:/docker_output $DOCKER_IMAGE_ID
sudo docker exec -t reposync '/docker_scripts/generate_reposync_folders.sh'

# So, now we have a folder with the three reposynched repositories, ready to build into the new ISO..



#exit 0



#rm -rf isolinux

#mkdir ./isolinux

rsync -a -h --partial --stats $LINUX_ISO_PATH/.discinfo $TARGET_ISO_DIRECTORY
rsync -a -h --partial --stats $LINUX_ISO_PATH/isolinux/ $TARGET_ISO_DIRECTORY
rsync -a -h --partial --stats --delete $LINUX_ISO_PATH/images/ $TARGET_ISO_DIRECTORY/images/
rsync -a -h --partial --stats --delete $LINUX_ISO_PATH/LiveOS/ $TARGET_ISO_DIRECTORY/LiveOS/

gunzip -c $LINUX_ISO_PATH/repodata/*comps.xml.gz > ./comps.xml

rsync -a -h --partial --stats --delete $LINUX_ISO_PATH/Packages/ $TARGET_ISO_DIRECTORY/Packages/

(cd isolinux && createrepo -g ../comps.xml .)


#Now copy kickstart file.
#cp -p custom/custom-kickstart.cfg ./isolinux/ks/ 
rsync -a -h --partial --stats --delete ./custom/custom-kickstart.cfg $TARGET_ISO_DIRECTORY/ks/
rsync -a -h --partial --stats ./custom/isolinux.cfg $TARGET_ISO_DIRECTORY


# Now copy the three reposync repositories into target directory:
rsync -a -h --partial --stats $DOCKER_OUTPUT_DIRECTORY/ $TARGET_ISO_DIRECTORY/
exit 0
(cd $TARGET_ISO_DIRECTORY/updates && createrepo .)
(cd $TARGET_ISO_DIRECTORY/extras && createrepo .)
(cd $TARGET_ISO_DIRECTORY/centosplus && createrepo .)

exit 0

#create repoc
#createrepo
#mkisofs – see shaun liu doc

mkisofs -o working_directory/centos-7-custom.iso -b isolinux.bin -c boot.cat -no-emul-boot -V 'CentOS 7 x86_64' -boot-load-size 4 -boot-info-table -R -J -v -T $TARGET_ISO_DIRECTORY
