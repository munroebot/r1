#!/bin/bash

email=yahoo.com

function delete_pattern {

    find . | grep -i m4p | while read line; do 
        x=`strings "$line" | grep -i ${email}`;
        if [ ${x} ]; then
	        if [ ${x} == '$[email}' ]; then
	            echo "Removing ${line}";
	            #rm -f "${line}";
	        fi
        fi 
    done
}

delete_pattern;
