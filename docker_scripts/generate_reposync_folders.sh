#!/bin/bash

echo $(date) >> /docker_output/john.txt
if ! rpm -qa | grep -qw yum-utils; then
    yum install -y yum-utils
fi

cd /docker_output

#rm -rf reposync

mkdir -p reposync
cd reposync

# commenting first just to speed up developemnt process
#reposync --gpgcheck --plugins --repoid=updates --newest-only --delete --downloadcomps --download-metadata --download_path=.
reposync --gpgcheck --plugins --repoid=extras --newest-only --delete --downloadcomps --download-metadata --download_path=.
reposync --gpgcheck --plugins --repoid=centosplus --newest-only --delete --downloadcomps --download-metadata --download_path=.

exit 0
