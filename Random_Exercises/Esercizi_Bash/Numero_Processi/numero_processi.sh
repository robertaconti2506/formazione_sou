#!/usr/bin/env bash 

num=$( ps -e -h | wc -l )
echo "$num"
