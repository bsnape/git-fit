module GitFit
  module Cli

    class VersionCommand < GitFitCommand

      def execute(view)
        view.output("Git-Fit Version: #{GitFit::VERSION}\n")
        view.report_success
      end
    end
  end
end
