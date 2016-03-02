#!/bin/bash
# update the system
release=`awk '{print $3}' /etc/redhat-release`
dnf update -y --enablerepo updates-testing
rm -rf /data/rpms/$release/*
cd /root/freeipa
rm dist/* -rf
git reset --hard
git pull
# Now let's apply patches
rm *.patch
cp /data/patches/* ./
for i in `ls *.patch` 
do 
  echo "applying $i" 
  git apply $i 
done
# Now build!
make rpms
mv -f dist/rpms/* /data/rpms/$release
git reset --hard
