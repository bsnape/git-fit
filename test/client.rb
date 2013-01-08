$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'history'
require 'working_copy'
require 'report'
require 'ruport'
require 'git_lib'

class Client
  history = History.new('/Users/bensnape/git/dit_automation_tests', 'HEAD', 0.5)
  working_copy = WorkingCopy.new '/Users/bensnape/git/dit_automation_tests'

  working_copy_output = working_copy.fast_find_in_working_copy
  history_output = history.search

  working_copy_report = Table("object sha", "size (KB)", "compressed (KB)", "path")
  history_report = Table("object sha", "size (MB)", "path", "commit details", "author")

  working_copy_output.each { |sha, (size, csize, path)| working_copy_report << [sha, size, csize, path] }
  history_output.each { |sha, size, path, where, who| history_report << [sha, size, path, where, who] }

  report = Report.new(working_copy_report.to_html, history_report.to_html)
  #(report.to_html(:ignore_table_width => true))

  report.create

end
