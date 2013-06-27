#!/bin/bash

set -e

if [[ "$1" == "" || "$2" == "" ]]; then
  echo "Usage: $0 <address_or_domain> <domains_txt>"
  exit 0
fi


if [[ "$1" == *"@"* ]]; then
  echo "It's an address"
  dom=`echo $1 | cut -f2 -d'@'`
else
  echo "it's a domain"
  dom=$1
fi


# Check not already present
if grep --quiet "^$dom\$" $2; then
  echo "Already present; quitting"
  exit 0
fi


# Append to bottom
echo "$dom" >> $2

# Sort
mv $2 temp_domains.txt
sort temp_domains.txt > domains.txt
rm -f temp_domains.txt


