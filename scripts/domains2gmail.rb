#!/usr/bin/env ruby

require 'time'

domains = File.new("#{File.dirname(__FILE__)}/../domains.txt", "r").read.split

filters = []

domains.each_slice(70) do |a|
  filters.push "
    <entry>
      <category term='filter'></category>
      <title>Mail Filter</title>
      <apps:property name='from' value='#{a.join(' OR ')}'/>
      <apps:property name='label' value='Recruitment'/>
      <apps:property name='shouldArchive' value='true'/>
    </entry>
  "
end

File.open("#{File.dirname(__FILE__)}/../gmailFilters.xml", 'w') do |f|
  f.write "<?xml version='1.0' encoding='UTF-8'?>
<feed xmlns='http://www.w3.org/2005/Atom' xmlns:apps='http://schemas.google.com/apps/2006'>
  <title>Mail Filters</title>
  #{filters.join}
</feed>
"
end
