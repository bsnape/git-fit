require 'erb'

def get_template()
  %{
        <DOCTYPE html  "-//W3C//DTD  1.0 //EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <title>Git HealthCheck Report</title>
        </head>
        <body>
                 <h1>Git HealthCheck Report</h1>
        </body>
        </html>
  }
end

class Report

  include ERB::Util

  def initialize(template)
    @template = template
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def save(file)
    Dir.mkdir 'report' unless File.directory? 'report'
    File.open("report/#{file}", "w+") do |f|
      f.write(render)
    end
  end

  list = Report.new(get_template)
  list.save('report.html')


end
