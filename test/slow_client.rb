$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'big_file_finder'
require 'ruport'

class SlowClient
  t1 = Time.now
  bff = BigFileFinder.new('/Users/bensnape/git/dit_automation_tests', 'HEAD', 0.03)
  output = bff.search

  report = Table("object sha", "size (MB)", "path", "commit details", "author")

  output.each { |sha, size, path, where, who| report << [sha, size, path, where, who] }

  puts report.to_text(:ignore_table_width => true)

  t2 = Time.now

  puts "Time taken (seconds): #{t2-t1}"

end
