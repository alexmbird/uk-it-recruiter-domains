#!/usr/bin/env python

import sys, re

sieveMatcher = re.compile(r'@[A-Z0-9\-\.]+', flags=re.IGNORECASE)

doms = dict()

f = open(sys.argv[1])
for line in f:
  #match = sieveMatcher.search(line)
  #print match 
  for m in sieveMatcher.findall(line):
    print m[1:]
  
