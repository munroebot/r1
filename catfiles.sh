#!/bin/bash

files_to_chown=`cat files_to_chown.txt`

for file in ${files_to_chown}
do
  echo $file
done
