$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'fast_big_file_finder'
require 'ruport'
require 'git_lib'

class FastClient
  f = FastBigFileFinder.new '/Users/bensnape/git/ITVOnline'

  output = f.fast_find_in_history

  report = Table("object sha", "size (KB)", "compressed size (KB)", "path")
  output.each { |sha, (size, csize, path)| report << [sha, size, csize, path] }

  puts '--- fast find in history ---'
  puts report.to_text(:ignore_table_width => true)


  output = f.fast_find_in_working_copy

  report = Table("object sha", "size (KB)", "compressed size (KB)", "path")
  output.each { |sha, (size, csize, path)| report << [sha, size, csize, path] }

  puts "\n--- fast find in working copy ---"
  puts report.to_text(:ignore_table_width => true)

end

