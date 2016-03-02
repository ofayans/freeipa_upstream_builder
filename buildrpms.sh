#!/bin/bash

# Pass integer fedora version as the first parameter
revision=$1

version=23
builder=f${version}builder

CONT_NAME=`docker ps -a | grep $builder | awk '{print $NF}'| tail -n 1`
# We assume that the docker images is called f23builder
if [[ -z "$CONT_NAME" ]]
# The container has not yet been initialized
then
  docker run -P -v $HOME/FreeIPA:/data:Z $builder &
  sleep 10
  CONT_NAME=`docker ps | grep $builder | awk '{print $NF}'`
else
  docker start $CONT_NAME
fi
echo "Container name is $CONT_NAME"
PORT=`docker ps | grep $CONT_NAME | sed -re 's/.*([0-9]{5}).*/\1/'`
echo "port is $PORT"
ssh localhost -p $PORT "/root/freeipa/build.sh $revision"
docker stop $CONT_NAME
docker rm $CONT_NAME
