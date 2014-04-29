uk-it-recruiter-domains
=======================
List of the domains of UK IT recruiters &amp; some scripts for processing it.

Why?
----
I get a torrent of email from IT recruiters. Some of them contain
well-targeted, intelligent specs for jobs I might actually want.  Most don't
and I am not excited at the prospect of a £15k starter role as an e-janitor
in Barnsley.  Having a list of domains the emails come from enables me to
maintain a sieve ruleset that automatically marks the lot read and archives
it into a 'recruiters' folder to dip into.

See also the [original blog post](https://mocko.org.uk/b/2011/09/08/silencing-the-flood-of-recruiter-emails-with-a-domain-list/).

Google Mail
-----------

GMail support is achieved via filters, you can import [gmailFilters.xml](https://github.com/alexmbird/uk-it-recruiter-domains/blob/master/gmailFilters.xml)
from the filters page in the interface.

A few things worth noting:

- Filters have a max query length, so we break them up into chunks of 70.
- By default we add a "Recruitment" label and archive any matches, you'll
  probably want to edit the filters created.
- If you reimport the filters, the originals remain.
- Update the XML based on domains.txt by running
  [scripts/domains2gmail.rb](https://github.com/alexmbird/uk-it-recruiter-domains/blob/master/scripts/domains2gmail.py).
