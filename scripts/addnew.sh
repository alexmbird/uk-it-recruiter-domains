#!/bin/bash

#
# Helper script to ease adding new domains
#

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

if [ ! -f "$2" ];
then
  echo "Domains file '$2' doesn't exist; cowardly refusing to create it"
  exit 1
fi


echo "Will add '$dom'"


# Check not already present
if grep --quiet "^$dom\$" $2; then
  echo "Already present; quitting"
  exit 0
fi


# Append to bottom
echo "$dom" >> $2

# Sort
mv $2 temp_domains.txt
LC_COLLATE=c sort temp_domains.txt > domains.txt
rm -f temp_domains.txt


# Recompile gmail filter
./scripts/domains2gmail.rb


# Add to GitHub
git add domains.txt
git add gmailFilters.xml
git commit -m "Add $dom"
git push


