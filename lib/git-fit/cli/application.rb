module GitFit
  module Cli

    class Application

      SUCCESS = 0
      ERROR = 1

      def initialize(argv)
        @options = GitFit::Cli::Options.new(argv)
        @status = SUCCESS
      end

      def execute
        begin
          cmd = @options.parse
          cmd.execute(self)
        rescue Exception => error
          $stderr.puts "Error: #{error}"
          @status = ERROR
        end
        @status
      end

      def output(text)
        print text
      end

      def report_success
        @status
      end

    end
  end
end
