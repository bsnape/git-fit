require 'ruport'

module GitHealthCheck
  module Cli

    class GitHealthCheckCommand

      def initialize(parser, options)
        @options = options
        @parser = parser
        @threshold = options[:threshold]
        @limit = options[:limit]
        @history = GitHealthCheck::History.new options
        @working_copy = GitHealthCheck::WorkingCopy.new options
        @packfile = GitHealthCheck::Packfile.new
      end

      def execute(view)
        @packfile.packfile_stats

        working_copy_output = @working_copy.find_in_working_copy
        history_output = @history.search

        working_copy_report = Table('object sha', 'size (MB)', 'path')
        history_report = Table('object sha', 'size (MB)', 'path', 'commit details', 'author')

        working_copy_output.each { |sha, size, path| working_copy_report << [sha, size, path] }
        history_output.each { |sha, size, path, where, who| history_report << [sha, size, path, where, who] }

        report = GitHealthCheck::Report.new(working_copy_report.to_html, history_report.to_html, @packfile, @options)
        report.create

        view.report_success
      end

    end
  end
end
