require 'erb'

module GitHealthCheck

  class Report

    def initialize(working_copy, history)
      @working_copy = working_copy
      @history = history
      @report_directory = Dir.pwd + "/healthcheck"
      @repository = Dir.pwd
    end

    def get_binding
      binding
    end

    def get_template
      File.read(File.dirname(__FILE__) + "/report/report.erb")
    end

    def create
      rhtml = ERB.new(get_template)
      output = rhtml.result(get_binding)

      Dir.mkdir @report_directory unless File.directory? @report_directory

      File.open(@report_directory + "/report.html", "w+") do |f|
        f.write output
      end
    end

  end
end
