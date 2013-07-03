require 'erb'

module GitFit

  class Report

    def initialize(working_copy, history, packfile, options)
      @working_copy = working_copy
      @history = history
      @packfile = packfile
      @repository = options[:repository]
      @report_directory = @repository + '/git-fit'
    end

    def get_binding
      binding
    end

    def get_template
      File.read(File.dirname(__FILE__) + '/report/report.erb')
    end

    def create
      rhtml = ERB.new(get_template)
      output = rhtml.result(get_binding)

      Dir.mkdir @report_directory unless File.directory? @report_directory

      File.open(@report_directory + '/report.html', 'w+') do |f|
        f.write output
      end
    end

  end
end
