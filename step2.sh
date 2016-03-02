#!/bin/bash

#STR=`date | md5sum | awk '{print $1}'`
#/usr/sbin/sshd -D -E /data/$STR.log
/usr/sbin/sshd -D 
