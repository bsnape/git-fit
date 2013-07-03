require 'ruport'

module GitFit
  module Cli

    class GitFitCommand

      def initialize(parser, options)
        @options = options
        @parser = parser
        @threshold = options[:threshold]
        @limit = options[:limit]
        @history = GitFit::History.new options
        @working_copy = GitFit::WorkingCopy.new options
        @packfile = GitFit::Packfile.new
      end

      def execute(view)
        @packfile.packfile_stats

        working_copy_output = @working_copy.find_in_working_copy
        history_output = @history.search

        working_copy_report = Table('object sha', 'size (MB)', 'path')
        history_report = Table('object sha', 'size (MB)', 'path', 'commit details', 'author')

        working_copy_output.each { |sha, size, path| working_copy_report << [sha, size, path] }
        history_output.each { |sha, size, path, where, who| history_report << [sha, size, path, where, who] }

        report = GitFit::Report.new(working_copy_report.to_html, history_report.to_html, @packfile, @options)
        report.create

        view.report_success
      end

    end
  end
end
