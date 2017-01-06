#!/bin/sh

# Build filtered and extended sieve script and uploaded it to your mailserver

# This is something timabell created for his own purposes, so is totally not
# general-purpose, but if anyone else wants it then perhaps they could send in
# pull-requests to make it more generally useful. Sharing this as a starting
# point.

# Depends on sieve-connect being available
# * http://packages.ubuntu.com/precise/net/sieve-connect
# * sudo apt-get install sieve-connect
# * https://github.com/philpennock/sieve-connect

# I actually like their newsletter
SKIP="elevatedirect"

user="yourmailuserhere"

# the file we'll build before sending it up the mail server
output=~/Documents/config/sieve.txt

# where the domain list lives
cd ~/repo/uk-it-recruiter-domains/

# just for kicks
echo -n "domain count: "
wc -l domains.txt

# this is a file with other sieve rules that I also want included. bring your own...
cat ~/Documents/config/sieve-part1.txt > "$output"

# Run the generator, filtering out anything matching the SKIP variable. Also
# strips off the "require" header as that can't be repeated and that's in my
# "part1" script.
scripts/domains2sieve.py domains.txt | egrep -v "$SKIP|require" >> "$output"

# say what it skipped (yes I know not very DRY. patches welcome...)
echo "skipped:"
scripts/domains2sieve.py domains.txt | egrep "$SKIP|require"

# Send it to the best mail host in the world.  You are using them aren't you?
# http://www.tuffmail.com/ You get what you pay for, and it's not free, but
# they know what a sieve script is and don't read your mail to sell ads like
# gmail.
echo "Uploading to tuffmail..."
# will prompt for the password.
sieve-connect -s managesieve.mxes.net -p 2000 --user $user --upload --localsieve "$output" --remotesieve all

# you hope...
echo "done."
