module GitHealthCheck
  module Cli

    class VersionCommand < GitHealthCheckCommand

      def execute(view)
        view.output("Git-Health-Check Version: #{GitHealthCheck::VERSION}\n")
        view.report_success
      end
    end
  end
end
