#!/bin/bash

#
# Helper script to ease adding new domains
#

set -e

if [[ "$1" == "" ]]; then
  echo "Usage: $0 <address_or_domain> [<domains_txt>]"
  exit 0
fi


if [[ "$1" == *"@"* ]]; then
  dom=`echo $1 | cut -f2 -d'@'`
  echo "domain extracted from email address: $dom"
else
  dom=$1
fi

DOMAINFILE="$2"
if [[ "$DOMAINFILE" == "" ]]; then
	DOMAINFILE="domains.txt"
fi

if [ ! -f "$DOMAINFILE" ];
then
  echo "Domains file '$DOMAINFILE' doesn't exist; cowardly refusing to create it"
  exit 1
fi


echo "Will add '$dom'"


# Check not already present
if grep --quiet "^$dom\$" $DOMAINFILE; then
  echo "Already present; quitting"
  exit 0
fi


# Append to bottom
echo "$dom" >> $DOMAINFILE

# Sort
mv $DOMAINFILE temp_domains.txt
LC_COLLATE=c sort temp_domains.txt > domains.txt
rm -f temp_domains.txt

# Add to GitHub
git add domains.txt
git commit -m "Add $dom"
