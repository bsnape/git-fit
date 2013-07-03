# Git Fit

This gem outputs a set of metrics for your Git repository which allows you to monitor its size over its lifetime.

It provides fairly basic but useful details about large files in both your `working copy` as well as in your `history`.

## Installation

Install the gem:

    $ gem install git-fit

## Usage

Currently, the gem is best utilised as a post-build step and possibly outside of your push-triggered CI job depending on
 the size of your repository.

Execution should take a couple of seconds for most people but for very large repositories
  with many thousands of commits - e.g. 1GB+ - it could take 10-15 minutes.

 To perform a default run (the history threshold is set at 0.5MB):

    $ gitfit

 To specify a threshold value (in MB) on the history reporting:

    $ gitfit -t 2

 A report is generated at `git-fit/report.html`

 To view a list of available commands:

    $ gitfit -h

    Usage: gitfit [option]

    Output metrics for your Git repository.

    Examples:
        gitfit
        gitfit -t 10
        gitfit --threshold 0.2
        gitfit -l 20
        gitfit --threshold 5 --limit 20
        gitfit -r projects/my_repo -t 10 -l 30

    Options:
        -v, --version                    Displays the gem version
        -h, --help                       Displays this help message
        -t, --threshold THRESHOLD        Specify minimum history threshold in MB (default 0.5)
        -l, --limit LIMIT                Specify working copy results limit (default 10)
        -r, --repository REPOSITORY      Specify the repository (current directory by default)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# To Do:

1. add timings
3. improve general logic - especially git_fit_command.rb
4. improve reporting - something better than ERB
5. explore the use of Thor instead of OptionParser
6. output number of commits - `git shortlog | grep -E '^[ ]+\w+' | wc -l` *or* `git log --pretty=format:'' | wc -l`
7. output total number of commits across all branches - `git rev-list --all | wc -l`
8. output contributors - `git shortlog | grep -E '^[^ ]'` *or* `git shortlog -n -s`
