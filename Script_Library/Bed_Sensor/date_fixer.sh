#!/bin/bash

TARGET_DIRECTORY="/home/ubuntu/linuxTesting/beddata/"
EXTENSION=".bd2"

SUBSTRING='2015_01'
REPLACEMENT='2014_12'

OLDDIRECTORY='2015/01'
NEWDIRECTORY='2014/12'


#	First move all files in the folder over to new directory
mv -v $OLDDIRECTORY/* $NEWDIRECTORY/

find $TARGET_DIRECTORY -name "2015_01_*$EXTENSION" | while read line; do

    UNALTERED_LINE=$line
    
    NEWLINE=${line/$SUBSTRING/$REPLACEMENT}
    
    mv $line $NEWLINE
    
	printf "Moved '"
done
