require 'ruport'

module GitHealthCheck
  module Cli

    class GitHealthCheckCommand

      def initialize(parser, threshold = 0.5)
        @threshold = threshold
        @parser = parser
        @repository = Dir.pwd
      end

      def execute(view)
        history = GitHealthCheck::History.new(@repository, 'HEAD', @threshold)
        working_copy = GitHealthCheck::WorkingCopy.new @repository
        packfile = GitHealthCheck::Packfile.new(@repository)
        packfile.packfile_stats

        working_copy_output = working_copy.fast_find_in_working_copy
        history_output = history.search

        working_copy_report = Table("object sha", "size (KB)", "compressed (KB)", "path")
        history_report = Table("object sha", "size (MB)", "path", "commit details", "author")

        working_copy_output.each { |sha, (size, csize, path)| working_copy_report << [sha, size, csize, path] }
        history_output.each { |sha, size, path, where, who| history_report << [sha, size, path, where, who] }

        report = GitHealthCheck::Report.new(working_copy_report.to_html, history_report.to_html, packfile)
        report.create

        view.report_success
      end

    end
  end
end
