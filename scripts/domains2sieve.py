#!/usr/bin/python

# Turn domains.txt into a sieve rule

import os, sys

f = open(sys.argv[1])
doms = f.readlines()
doms = map( lambda s: s.strip(), doms )
doms = filter( lambda s: not s.startswith('#'), doms )
doms = filter( lambda s: len(s) > 0, doms )
doms.sort()

def chunks(l, n):
    """ Yield successive n-sized chunks from l.
    """
    for i in xrange(0, len(l), n):
        yield l[i:i+n]


print 'require ["fileinto"];'
print 'if address :matches "from" ['

for d in doms[:-1]:
    print "  \"*@%s\"," % d

d = doms[-1]   # last one needs no trailing comma
print "  \"*@%s\"" % d


print """
  ] {
    #setflag "\\Seen";
    fileinto "Recruiters";
    stop;
}
""".strip()

