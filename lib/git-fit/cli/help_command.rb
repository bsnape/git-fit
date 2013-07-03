module GitFit
  module Cli

    class HelpCommand < GitFitCommand

      def execute(view)
        view.output(@parser.to_s)
        view.report_success
      end
    end
  end
end
