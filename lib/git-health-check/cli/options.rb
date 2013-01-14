require 'optparse'

module GitHealthCheck
  module Cli

    class Options

      def initialize(argv)
        @argv = argv
        @parser = OptionParser.new
        @command_class = GitHealthCheckCommand
        set_parser_options
      end

      def banner
        return <<EOB
Usage: ghc [option]

Output metrics for your Git repository.

Examples:
    ghc
    ghc -t 10
    ghc -t 0.2

EOB
      end

      def set_parser_options
        @parser.banner = banner

        @parser.separator "Options:"

        @parser.on("-v", "--version", "Displays the gem version") { @command_class = VersionCommand }

        @parser.on("-h", "--help", "Displays this help message") { @command_class = HelpCommand }

        @parser.on("-t", "--threshold THRESHOLD", Float, "Specify history size threshold in mB (default 0.5)") do |n|
          @threshold = n
        end
      end

      def parse
        @parser.parse!(@argv)
        @threshold ? @command_class.new(@parser, @threshold) : @command_class.new(@parser)
      end

    end
  end
end
