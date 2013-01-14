module GitHealthCheck
  module Cli

    class HelpCommand < GitHealthCheckCommand

      def initialize(parser)
        @parser = parser
      end

      def execute(view)
        view.output(@parser.to_s)
        view.report_success
      end
    end
  end
end
