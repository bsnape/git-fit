$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'fast_big_file_finder'
require 'big_file_finder'
require 'report'
require 'ruport'
require 'git_lib'

class Client
  file_finder = BigFileFinder.new('/Users/bensnape/git/dit_automation_tests', 'HEAD', 0.5)
  fast_file_finder = FastBigFileFinder.new '/Users/bensnape/git/dit_automation_tests'

  history_output = fast_file_finder.fast_find_in_history
  working_copy_output = fast_file_finder.fast_find_in_working_copy
  thorough_history_output = file_finder.search


  history_report = Table("object sha", "size (KB)", "compressed size (KB)", "path")
  working_copy_report = Table("object sha", "size (KB)", "compressed size (KB)", "path")
  thorough_history_report = Table("object sha", "size (MB)", "path", "commit details", "author")


  history_output.each { |sha, (size, csize, path)| history_report << [sha, size, csize, path] }
  working_copy_output.each { |sha, (size, csize, path)| working_copy_report << [sha, size, csize, path] }
  thorough_history_output.each { |sha, size, path, where, who| thorough_history_report << [sha, size, path, where, who] }


  report = Report.new(history_report.to_html, working_copy_report.to_html, thorough_history_report.to_html)
  #(report.to_html(:ignore_table_width => true))

  report.create

end
