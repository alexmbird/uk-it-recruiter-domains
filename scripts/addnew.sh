#!/bin/bash

#
# Helper script to ease adding new domains
#

set -e



function print_usage {
    
    echo
    echo "Add a domain to domains.txt if it isn't already present"
    echo
    echo "Usage:"
    echo
    echo "  $0 [options] <recruiter email address | recruiter domain>"
    echo
    echo "Options:"
    echo 
    echo "  -d <f>   - alternate domains.txt file <f>"
    echo "  -c       - automatically commit"
    echo "  -p       - automatically push to GitHub; implies -c"
    echo "  -h       - this help text"
    echo
    
}




# Execute getopt
ARGS=$(getopt hcpd: "$@")



# Bad arguments
if [ $? -ne 0 ];
then
    print_usage
    exit 1
fi


# A little magic
eval set -- "$ARGS"



# Set defaults
GIT_PUSH=0
GIT_COMMIT=0
DOMAINFILE="domains.txt"



# Now go through all the options
while true; do
  case "$1" in
    -h)
      print_usage
      exit 0
      shift;;
    -c)
      GIT_COMMIT=1
      shift;;
    -p)
      GIT_PUSH=1
      GIT_COMMIT=1
      shift;;
    -d)
      DOMAINFILE="$2"
      shift 2;;
    --)
      shift
      break;;
  esac
done




# No email/domain specified?
if [[ "$1" == "" ]]; then
    print_usage
    exit 0
fi


# Check domain file really exists
if [ ! -f "$DOMAINFILE" ];
then
  echo "Domains file '$DOMAINFILE' doesn't exist; cowardly refusing to create it."
  echo "Do 'touch $DOMAINFILE' and try again if you really want this."
  exit 1
fi


# Extract our domain
if [[ "$1" == *"@"* ]]; then
  dom=`echo $1 | cut -f2 -d'@'`
  echo "domain extracted from email address: $dom"
else
  dom=$1
fi

# Make domain lowercase
dom=`echo "${dom}" | tr '[:upper:]' '[:lower:]'`


# Check not already present
if grep --quiet "^$dom\$" $DOMAINFILE; then
  echo "'$dom' was already present; nothing to do"
  exit 0
fi


# Append to bottom
echo "Adding '$dom' to $DOMAINFILE"
echo "$dom" >> $DOMAINFILE

# Sort
mv $DOMAINFILE temp_domains.txt
LC_COLLATE=c sort temp_domains.txt > $DOMAINFILE
rm -f temp_domains.txt

# Count
NUM_DOMAINS=`wc -l $DOMAINFILE | awk '{print $1;}'`
echo "$NUM_DOMAINS now in the list"

# Automatically commit
if [ $GIT_COMMIT == 1 ];
then
    git add "$DOMAINFILE"
    git commit -m "Added $dom"
else
    echo "Don't forget to commit"
fi

# Add to GitHub
if [ $GIT_PUSH == 1 ];
then
    git push
else
    echo "Don't forget to push to GitHub"
fi

