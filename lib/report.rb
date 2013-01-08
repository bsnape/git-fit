require 'erb'

class Report

  def initialize(fast_history, fast_working_copy, thorough_history)
    @fast_history = fast_history
    @fast_working_copy = fast_working_copy
    @thorough_history = thorough_history
    @report_directory = "#{File.dirname(__FILE__)}/../report"
  end

  def get_binding
    binding
  end

  def get_template
    File.read("#@report_directory/report.erb")
  end

  def create
    rhtml = ERB.new(get_template)
    output = rhtml.result(get_binding)

    Dir.mkdir @report_directory unless File.directory? @report_directory

    File.open("#@report_directory/report.html", "w+") do |f|
      f.write output
    end
  end

end
