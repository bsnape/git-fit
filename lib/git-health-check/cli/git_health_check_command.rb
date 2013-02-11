require 'ruport'

module GitHealthCheck
  module Cli

    class GitHealthCheckCommand

      def initialize(parser, options)
        @threshold = options[:threshold]
        @limit = options[:limit]
        @parser = parser
        @repository = Dir.pwd
      end

      def execute(view)
        history = GitHealthCheck::History.new(@repository, @threshold)
        working_copy = GitHealthCheck::WorkingCopy.new @repository
        packfile = GitHealthCheck::Packfile.new(@repository)
        packfile.packfile_stats

        working_copy_output = working_copy.find_in_working_copy @limit
        history_output = history.search

        working_copy_report = Table('object sha', 'size (MB)', 'path')
        history_report = Table('object sha', 'size (MB)', 'path', 'commit details', 'author')

        working_copy_output.each { |sha, size, path| working_copy_report << [sha, size, path] }
        history_output.each { |sha, size, path, where, who| history_report << [sha, size, path, where, who] }

        report = GitHealthCheck::Report.new(working_copy_report.to_html, history_report.to_html, packfile)
        report.create

        view.report_success
      end

    end
  end
end
